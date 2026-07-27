# OSXPhotos Archive

This feature is enabled only by `modules/hosts/mac-studio.nix`. It installs
`osxphotos`, `exiftool`, and `jq` through Homebrew and runs one login-triggered
archive attempt through a user `launchd` agent.

The initial implementation is intentionally conservative:

- The System Photo Library is the source of truth.
- The NAS archive is append-only from the Mac's point of view.
- A local staging directory is retained when the NAS is unavailable or an
  upload fails.
- The active projection is separate writable media for Immich.
- B2/restic is documented below but is not configured by this Nix change.

## NAS Setup

1. In Unraid, install or verify the **User Scripts** plugin.
2. Create a dedicated non-administrator user named `photos-archive`.
3. Set the `photos` SMB share to **Private**.
4. Grant `photos-archive` access to the `photos` share. Do not reuse an
   administrator account.
5. The resulting paths must be:

   ```text
   /mnt/user/photos/icloud/selene/archive
   /mnt/user/photos/icloud/selene/active
   /mnt/user/photos/icloud/selene/_deleted
   /mnt/user/photos/icloud/selene/_control
   ```

6. Create a root-owned User Script that runs every 15 minutes. Replace the
   `find` path if the share uses a different Unraid path:

   ```bash
   #!/bin/bash
   set -euo pipefail

   root=/mnt/user/photos/icloud/selene
   for tree in archive _deleted; do
     find "$root/$tree" -type f \
       ! -name '*.osxphotos-partial-*' \
       ! -name '*.incomplete' \
       -mmin +15 -exec chattr +i -- {} +
   done
   ```

   Configure it to run as root every 15 minutes. Never include `active` or
   `_control` in this script. The 15-minute delay lets the Mac finish writing
   a media file and its sidecars.

7. Verify that the Mac can create a new file in `archive` and `active`.
8. After the grace period, verify that an archive file cannot be changed or
   deleted by `photos-archive`.
9. For an administrator recovery, temporarily run `chattr -i` as root,
   perform the recovery, and reapply `chattr +i`.

The archive and `_deleted` trees are never cleaned automatically.

## Mac Setup

1. Ensure Photos is using the System Photo Library.
2. In Photos settings, select **Download Originals to this Mac**. The job
   does not automatically request cloud downloads with AppleScript.
3. Store the SMB password in Keychain. Run this interactively and enter the
   password when prompted:

   ```bash
   security add-internet-password \
     -s 10.10.40.10 \
     -r smb \
     -a photos-archive \
     -w
   ```

4. Test the mount manually:

   ```bash
   mkdir -p /Volumes/photos
   mount_smbfs -N //photos-archive@10.10.40.10/photos /Volumes/photos
   mount | grep '/Volumes/photos'
   ```

5. Grant the required macOS privacy permission to the Homebrew `osxphotos`
   executable and validate that this command can read the library:

   ```bash
   /opt/homebrew/bin/osxphotos list
   /opt/homebrew/bin/osxphotos info
   ```

   macOS may require allowing the terminal or the executable in Privacy &
   Security settings. Do not grant unrelated tools access to the library.

6. Apply the Studio configuration:

   ```bash
   just build-darwin studio
   ```

7. Before relying on the login agent, run the generated command manually and
   inspect `~/Library/Logs/osxphotos-archive/`. Run a dry-run separately with
   `osxphotos export --dry-run --verbose` if you need to validate templates.
8. Test a representative original, edited asset, RAW+JPEG pair, Live Photo,
   JSON sidecar, and XMP sidecar before allowing a full initial export.

The local retry queue is under:

```text
~/Library/Application Support/osxphotos-archive/staging
```

It is not deleted until the current staging batch has been reconciled. The
queue limit is 50 GiB; reaching it stops new work and emits a notification.

## Archive Layout

```text
photos/icloud/selene/
├── archive/YYYY/MM/DD/
├── active/YYYY/MM/DD/
├── _deleted/YYYY/MM/DD/
└── _control/
```

Archive filenames preserve the source name and add the Photos UUID:

```text
DCP_1133__UUID.JPG
DCP_1133__UUID.DNG
DCP_1133__UUID__edited.JPG
DCP_1133__UUID__live.MOV
DCP_1133__UUID.json
DCP_1133__UUID.xmp
```

Originals remain unsuffixed apart from the UUID. Edited and component files
use role suffixes. Invalid dates use `_undated`.

The complete `osxphotos` JSON record is retained. XMP is provided for Immich
and supported metadata is embedded into the one exported media file by
`osxphotos`/`exiftool`; no metadata-enriched duplicate image is created.

## Immich Setup

1. Mount only the NAS `active` directory into the Immich server container.
   Do not mount `archive`, `_deleted`, or `_control`.
2. Use the existing container path you choose for that mount and create a
   dedicated read-write Immich external library for it.
3. Record that library's immutable numeric ID in the Mac-local deployment
   configuration. Do not put the ID or API token in this Nix repository.
4. Store an Immich API token in macOS Keychain. The token should have only the
   permissions needed to trigger an external-library scan.
5. Configure the Mac sync to trigger a scan only after the active projection
   and control manifests have been updated.

Immich may enrich active XMP and database metadata. Those changes remain in
`active` and are not copied into the immutable archive. Immich deletions are
tracked per active variant, so deleting one member of a JPG+RAW pair does not
automatically hide the other member. Explicit restore tooling should remove a
variant from the hidden manifest.

## Deletion Semantics

An iCloud deletion requires two consecutive clean observations. A run with
unavailable originals, export errors, or an unreadable library does not count.
After confirmation, the exporter writes a tombstone, removes only the active
projection, and retains the archive copy indefinitely. If the asset returns,
the active projection can be rebuilt without overwriting the archive.

## B2/restic (Deferred)

B2 is intentionally not configured by this change. The planned follow-up is
an Unraid User Script running daily at 06:00:

- Create a dedicated private B2 bucket and bucket-scoped application key.
- Run restic on Unraid with encryption and repository deduplication.
- Back up `archive`, `_deleted`, `_control`, and active XMP sidecars.
- Exclude duplicated active media and the separately backed-up Immich database.
- Retain 30 daily, 90 weekly, and 1-year monthly snapshots.
- Decide the B2 Object Lock period before enabling pruning. The previously
  discussed 90-day lock is not enabled yet.
- Store B2 credentials and the restic password in a root-only Unraid secrets
  file, never in a User Script body or command-line arguments.

Run `restic check` periodically and perform restore tests before treating the
backup as operational.
