# --with is handled here, not by the upstream OpenCode CLI.
opencode() {
  local -a arguments integrations environment
  local -A selected
  local value integration token cert servers config_content
  arguments=()
  integrations=()
  environment=()

  while (( $# )); do
    case "$1" in
      --with)
        if (( $# < 2 )) || [[ -z "$2" || "$2" == -* ]]; then
          print -u2 -- 'opencode: --with requires sigrid, gitlab, or sigrid,gitlab'
          return 2
        fi
        value="$2"
        shift 2
        ;;
      --with=*)
        value="${1#--with=}"
        shift
        ;;
      --)
        arguments+=("$@")
        break
        ;;
      *)
        arguments+=("$1")
        shift
        continue
        ;;
    esac

    if [[ -z "$value" || "$value" == ,* || "$value" == *, || "$value" == *,,* ]]; then
      print -u2 -- 'opencode: --with requires a non-empty integration list'
      return 2
    fi
    for integration in "${(@s:,:)value}"; do
      case "$integration" in
        sigrid|gitlab) ;;
        *)
          print -u2 -- "opencode: unknown integration '$integration' (available: sigrid, gitlab)"
          return 2
          ;;
      esac
      if [[ -z "${selected[$integration]-}" ]]; then
        selected[$integration]=1
        integrations+=("$integration")
      fi
    done
  done

  if (( ${#integrations} == 0 )); then
    command opencode "${arguments[@]}"
    return $?
  fi

  # Validate configuration and certificate before requesting any credentials.
  config_content="${OPENCODE_CONFIG_CONTENT:-}"
  [[ -n "$config_content" ]] || config_content='{}'
  if ! print -r -- "$config_content" | @jq@ -e 'type == "object"' >/dev/null; then
    print -u2 -- 'opencode: OPENCODE_CONFIG_CONTENT must be a JSON object'
    return 2
  fi
  if [[ -n "${selected[gitlab]-}" ]]; then
    cert="${GITLAB_CLIENT_CERT:-$HOME/certs/gitlab-at-rws-nl-cert/git-rws-nl-mtls.pem}"
    if [[ ! -r "$cert" ]]; then
      print -u2 -- "GitLab client certificate not readable: $cert"
      return 1
    fi
  fi

  servers='{}'
  for integration in "${integrations[@]}"; do
    case "$integration" in
      sigrid)
        token="$(sigrid_mcp_token)" || return
        [[ -n "$token" ]] || { print -u2 -- 'Sigrid MCP token cannot be empty'; return 1; }
        environment+=("SIGRID_MCP_TOKEN=$token")
        servers="$(print -r -- "$servers" | @jq@ -c '. + {"sigrid-says":{"type":"remote","url":"https://sigrid-says.com/mcp","oauth":false,"headers":{"Authorization":"Bearer {env:SIGRID_MCP_TOKEN}"}}}')" || return
        ;;
      gitlab)
        token="$(gitlab_mcp_token)" || return
        [[ -n "$token" ]] || { print -u2 -- 'GitLab PAT cannot be empty'; return 1; }
        environment+=("GITLAB_PAT=$token" "GITLAB_CLIENT_CERT=$cert")
        servers="$(print -r -- "$servers" | @jq@ -c '. + {"gitlab":{"type":"local","command":["@gitlabBridge@"],"environment":{"GITLAB_PAT":"{env:GITLAB_PAT}","GITLAB_CLIENT_CERT":"{env:GITLAB_CLIENT_CERT}"}}}')" || return
        ;;
    esac
  done
  config_content="$(print -r -- "$config_content" | @jq@ -c --argjson servers "$servers" '.mcp.servers = ((.mcp.servers // {}) + $servers)')" || return

  # The shared service cannot inherit this invocation's config or credentials.
  # Export only inside a subshell; keep secrets out of external command arguments.
  (
    export OPENCODE_CONFIG_CONTENT="$config_content"
    for value in "${environment[@]}"; do
      export "$value"
    done
    command opencode --standalone "${arguments[@]}"
  )
}

opencode_sig() {
  opencode --with sigrid "$@"
}

opencode_gitlab() {
  opencode --with gitlab "$@"
}
