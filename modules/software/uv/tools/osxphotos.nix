_: {
  repository.features = [
    {
      homeManager = {
        targets = ["studio"];
        module = {
          programs.uv.tool.packages = ["osxphotos"];
        };
      };
    }
  ];
}
