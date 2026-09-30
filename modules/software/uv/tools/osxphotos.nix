_: {
  repository.features = [
    {
      homeManager = {
        targets = ["*"];
        module = {
          programs.uv.tool.packages = ["osxphotos"];
        };
      };
    }
  ];
}
