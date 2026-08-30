_: {
  nixos.base = {config, ...}: {
    programs._1password.enable = true;
    programs._1password-gui = {
      enable = true;
      polkitPolicyOwners = [config.myConfig.user.name];
    };
  };
  darwin.base = {pkgs, ...}: {
    programs._1password.enable = true;
    environment.systemPackages = with pkgs; [_1password-cli _1password-gui];
  };
  homeManager.base = {pkgs, ...}: {
    myConfig.git.signing = {
      key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7XD47kGwOQQetoxcQOb4TvoqNyNc7LopmaRTkrsxyt7AAtArHIHhX1107tnSfmArgAYf4PPxonoiNfzO5i0HiT11zy9JK1CbrwIWN87zSW1npl9kaQowXMbWC+2OeixTPRIaOh5l6rsUQbuJBZUaHghznXFqtWZpoyhuHub7hOaFahun3ySoAz9gtKz0cuA+g5JxkoqG/mzr+y11iVR1Tn+n0jqRQPPodOehKHYLnQJT5fEvyVHP459qMWgICPPtHl4+YuwO4hBiUpZvHikOeYsDl0cplc8uGHzn95dxs1zfxStCYesdGn7maEFvfREgw8cNOzRh5WGRJJDbkqQiKbPYkD9TjOTNorysJaS3cE4BIeRQFraJRinWRiMvVTsVSXI/XD+CT1WjP/IyYcsNfFbgbsljssVZceMGxmUkE3i9STB8t+RqhXg05JO87bCAofzPlPLskHGBqsM1eS/1QItadXeKS2ttu0agpdo0/i2O1PjEABYnVE/zhvJ/mqjc=";
      sshSignProgram =
        if pkgs.stdenv.isDarwin
        then "${pkgs._1password-gui}/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
        else "${pkgs._1password-gui}/bin/op-ssh-sign";
    };
    myConfig.ssh.identityAgent =
      if pkgs.stdenv.isDarwin
      then "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\""
      else "~/.1password/agent.sock";
  };
}
