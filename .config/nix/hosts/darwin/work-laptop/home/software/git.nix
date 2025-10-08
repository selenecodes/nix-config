{ pkgs, ... }: {
  programs.git.includes = [
    {
      condition = "gitdir:~/Documents/code/rws/";
      contents = {
        user = {
          email = "selene.blok@rws.nl";
          signingkey = "";
        };
      };
    }
  ];
}
