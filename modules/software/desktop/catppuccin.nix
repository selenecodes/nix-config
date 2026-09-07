_: {
  repository.features = [
    {
      homeManager = {
        targets = ["studio"];
        module = {
          catppuccin = {
            enable = true;
            flavor = "frappe";
            starship.enable = true;
          };
        };
      };
    }
  ];
}
