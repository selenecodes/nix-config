_: {
  homeManager.base = {
    lib,
    pkgs,
    ...
  }: {
    home.sessionPath =
      lib.optionals pkgs.stdenv.isDarwin ["/opt/homebrew/opt/libpq/bin"]
      ++ lib.optionals pkgs.stdenv.isLinux ["$HOME/.local/bin"];

    programs.zsh = {
      enable = true;
      enableCompletion = true;

      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      localVariables.HISTDUP = "erase";

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
          "kubectl"
          "kubectx"
          "command-not-found"
          "docker"
          "docker-compose"
        ];
      };

      history = {
        append = true;
        extended = true;
        findNoDups = true;
        ignoreAllDups = true;
        ignoreDups = true;
        ignoreSpace = true;
        path = "$HOME/.zsh_history";
        save = 5000;
        saveNoDups = true;
        share = true;
        size = 5000;
      };

      shellAliases = {
        ls = "ls --color";
        vim = "nvim";
        c = "clear";
        composelint = "npx dclint --fix";
      };

      initContent = lib.mkBefore ''
        if [[ "$OSTYPE" == darwin* ]] && [[ -f "/opt/homebrew/bin/brew" ]]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        fi

        eval "$(fnm env)"

        ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"

        if [[ ! -d "$ZINIT_HOME" ]]; then
          mkdir -p "$(dirname "$ZINIT_HOME")"
          git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
        fi

        source "''${ZINIT_HOME}/zinit.zsh"

        zinit light zsh-users/zsh-completions
        zinit light Aloxaf/fzf-tab

        zinit cdreplay -q

        bindkey -e
        bindkey '^p' history-search-backward
        bindkey '^n' history-search-forward
        bindkey '^[w' kill-region

        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

        GPG_TTY=$(tty)
        export GPG_TTY
      '';
    };
  };
}
