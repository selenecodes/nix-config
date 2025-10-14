{ pkgs, ... }: {
  programs.git.signing.key = "DACDCE7E426244FC";
  programs.git.includes = [
    {
      condition = "gitdir:~/Documents/code/rws/";
      contents = {
        user = {
          email = "selene.blok@rws.nl";
          signingkey = "8DF95C3163537204";
        };
      };
    }
  ];
}
