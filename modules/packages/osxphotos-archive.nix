_: {
  darwin.osxphotosArchive = _: {
    homebrew = {
      taps = ["RhetTbull/osxphotos"];
      brews = ["osxphotos" "exiftool" "jq"];
    };
  };

  homeManager.osxphotosArchive = {
    config,
    pkgs,
    ...
  }: let
    home = config.home.homeDirectory;
    stateDir = "${home}/Library/Application Support/osxphotos-archive";
    logDir = "${home}/Library/Logs/osxphotos-archive";
    script = pkgs.writeShellScriptBin "osxphotos-archive" ''
      set -euo pipefail

      readonly mount_point="/Volumes/photos"
      readonly root="$mount_point/icloud/selene"
      readonly archive="$root/archive"
      readonly active="$root/active"
      readonly deleted="$root/_deleted"
      readonly control="$root/_control"
      readonly local_state="${stateDir}"
      readonly staging="$local_state/staging"
      readonly local_manifest="$local_state/manifest.tsv"
      readonly lock="$local_state/run.lock"
      readonly log_dir="${logDir}"
      readonly photos="/opt/homebrew/bin/osxphotos"
      readonly jq="/opt/homebrew/bin/jq"
      readonly mount_user="photos-archive"
      readonly max_queue_bytes=53687091200
      readonly retry_limit=1800

      mkdir -p "$local_state" "$staging" "$log_dir"
      exec >>"$log_dir/run-$(date +%Y-%m-%d).log" 2>&1
      printf '\n[%s] osxphotos archive run started\n' "$(date -Is)"

      if ! mkdir "$lock" 2>/dev/null; then
        printf '[%s] another run is active; exiting\n' "$(date -Is)"
        exit 0
      fi
      trap 'rmdir "$lock" 2>/dev/null || true' EXIT

      is_smb_mount() {
        mount | /usr/bin/grep -E "^//[^ ]+@10\\.10\\.40\\.10/photos on /Volumes/photos \\(smbfs" >/dev/null
      }

      mount_share() {
        local waited=0
        local backoff=5
        while ! is_smb_mount; do
          if [ "$waited" -ge "$retry_limit" ]; then
            printf '[%s] NAS unavailable after %ss; retaining local queue\n' "$(date -Is)" "$waited"
            return 1
          fi
          if [ ! -d "$mount_point" ]; then
            /bin/mkdir -p "$mount_point"
          fi
          /sbin/mount | /usr/bin/grep -q "on $mount_point " || \
            /sbin/mount_smbfs -N "//$mount_user@10.10.40.10/photos" "$mount_point" || true
          /bin/sleep "$backoff"
          waited=$((waited + backoff))
          backoff=$((backoff < 300 ? backoff * 2 : 300))
        done
        [ -d "$root" ] || /bin/mkdir -p "$root"
        is_smb_mount
      }

      queue_size() {
        /usr/bin/du -sk "$staging" | /usr/bin/awk '{print $1 * 1024}'
      }

      copy_verified() {
        local source="$1" destination="$2" temp hash_source hash_destination
        /bin/mkdir -p "$(/usr/bin/dirname "$destination")"
        temp="$destination.osxphotos-partial-$$"
        /usr/bin/ditto "$source" "$temp"
        hash_source=$(/usr/bin/shasum -a 256 "$source" | /usr/bin/awk '{print $1}')
        hash_destination=$(/usr/bin/shasum -a 256 "$temp" | /usr/bin/awk '{print $1}')
        [ "$hash_source" = "$hash_destination" ] || {
          /bin/rm -f "$temp"
          return 1
        }
        /bin/mv "$temp" "$destination"
      }

      reconcile_file() {
        local source="$1" relative="$2" destination="$archive/$relative" existing_hash source_hash versioned
        source_hash=$(/usr/bin/shasum -a 256 "$source" | /usr/bin/awk '{print $1}')
        if [ -f "$destination" ]; then
          existing_hash=$(/usr/bin/shasum -a 256 "$destination" | /usr/bin/awk '{print $1}')
          [ "$source_hash" = "$existing_hash" ] && return 0
          versioned="$destination.__v$(date -u +%Y%m%dT%H%M%SZ)-$source_hash"
          [ -e "$versioned" ] || copy_verified "$source" "$versioned"
        else
          copy_verified "$source" "$destination"
        fi
      }

      reconcile_sidecar() {
        local source="$1" relative="$2" destination="$archive/$relative" source_hash existing_hash
        source_hash=$(/usr/bin/shasum -a 256 "$source" | /usr/bin/awk '{print $1}')
        if [ -f "$destination" ]; then
          existing_hash=$(/usr/bin/shasum -a 256 "$destination" | /usr/bin/awk '{print $1}')
          [ "$source_hash" = "$existing_hash" ] && return 0
          destination="$destination.__v$(date -u +%Y%m%dT%H%M%SZ)-$source_hash"
          [ -e "$destination" ] || copy_verified "$source" "$destination"
        else
          copy_verified "$source" "$destination"
        fi
      }

      sync_active() {
        local batch="$1" source relative destination
        while IFS= read -r -d $'\0' source; do
          relative="''${source#"$batch/"}"
          case "$relative" in
            *.json)
              reconcile_sidecar "$source" "$relative"
              continue
              ;;
            *.xmp|*.XMP)
              reconcile_sidecar "$source" "$relative"
              destination="$active/$relative"
              [ -e "$destination" ] || copy_verified "$source" "$destination"
              continue
              ;;
          esac
          reconcile_file "$source" "$relative"
          destination="$active/$relative"
          [ -e "$destination" ] || copy_verified "$source" "$destination"
        done < <(/usr/bin/find "$batch" -type f -print0)
      }

      reconcile_batches() {
        local batch
        while IFS= read -r -d $'\0' batch; do
          printf '[%s] reconciling %s\n' "$(date -Is)" "$batch"
          sync_active "$batch"
          printf '%s\t%s\n' "$batch" "uploaded" >>"$local_manifest"
          /bin/rm -rf "$batch"
        done < <(/usr/bin/find "$staging" -mindepth 1 -maxdepth 1 -type d ! -name current -print0 | /usr/bin/sort -z)
      }

      [ -x "$photos" ] || { printf 'missing %s\n' "$photos"; exit 1; }
      [ -x "$jq" ] || { printf 'missing %s\n' "$jq"; exit 1; }
      mount_share || exit 0
      /bin/mkdir -p "$archive" "$active" "$deleted" "$control"

      if [ "$(queue_size)" -ge "$max_queue_bytes" ]; then
        printf '[%s] local staging queue exceeds 50 GiB; refusing new work\n' "$(date -Is)"
        /usr/bin/osascript -e 'display notification "osxphotos archive queue exceeds 50 GiB" with title "Photo archive paused"' || true
        exit 1
      fi

      reconcile_batches
      /bin/mkdir -p "$staging/current"
      "$photos" export "$staging/current" \
        --export-by-date \
        --directory "{created.year}/{created.mm}/{created.dd,undated}" \
        --filename "{original_name}_{uuid}" \
        --edited-suffix "__edited" \
        --sidecar JSON --sidecar XMP --sidecar-drop-ext \
        --exiftool --retry 3 \
        --exportdb "$local_state/export.db" \
        --library "$HOME/Pictures/Photos Library.photoslibrary"

      # The JSON export is the complete record; jq removes only volatile exporter fields.
      while IFS= read -r -d $'\0' json; do
        temp="$json.normalized"
        "$jq" -S 'del(.export_date, .export_path, .exporter_version)' "$json" >"$temp"
        /bin/mv "$temp" "$json"
      done < <(/usr/bin/find "$staging/current" -type f -iname '*.json' -print0)

      batch="$staging/$(date -u +%Y%m%dT%H%M%SZ)-$$"
      /bin/mv "$staging/current" "$batch"
      reconcile_batches
      printf '[%s] archive run completed\n' "$(date -Is)"
    '';
  in {
    home.packages = [script];

    home.file."Library/Application Support/osxphotos-archive/README".text = ''
      Configure the SMB Keychain item and Immich values using the repository runbook.
      Do not place credentials in this directory.
    '';

    launchd.agents.osxphotos-archive = {
      enable = true;
      config = {
        ProgramArguments = ["${script}/bin/osxphotos-archive"];
        EnvironmentVariables = {
          PATH = "/opt/homebrew/bin:/usr/bin:/bin";
        };
        RunAtLoad = true;
        ProcessType = "Background";
        StandardOutPath = "${logDir}/launchd.out.log";
        StandardErrorPath = "${logDir}/launchd.err.log";
      };
    };
  };
}
