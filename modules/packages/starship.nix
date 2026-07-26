_: {
  homeManager.base = {pkgs, ...}: {
    catppuccin.starship.enable = pkgs.stdenv.isLinux;

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        format = "$username$hostname$directory$git_branch$git_status$cmd_duration\n$character";

        character = {
          success_symbol = "[❯](purple)";
          error_symbol = "[❯](red)";
          vimcmd_symbol = "[❮](green)";
        };

        directory = {
          style = "blue bold";
          truncation_length = 3;
          truncate_to_repo = false;
        };

        git_branch = {
          symbol = "";
          format = "[$branch]($style) ";
          style = "green";
        };

        git_status = {
          format = "[$all_status$ahead_behind]($style) ";
        };

        cmd_duration = {
          min_time = 5000;
          format = "took [$duration]($style) ";
          style = "yellow";
        };

        username = {
          show_always = false;
          format = "[$user]($style)";
          style_root = "bold red";
          style_user = "dimmed white";
        };

        hostname = {
          ssh_only = true;
          format = "[@$hostname]($style) ";
          style = "dimmed white";
        };
      };
    };
  };
}
