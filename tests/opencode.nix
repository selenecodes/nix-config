{lib}: let
  inputs.opencode.packages.aarch64-darwin.opencode.version = "2.4.1";
  feature = builtins.head (import ../modules/software/opencode.nix {inherit lib inputs;}).repository.features;
  module = feature.homeManager.module {
    config.home.homeDirectory = "/home/test";
    pkgs = {
      stdenv.hostPlatform = {
        system = "aarch64-darwin";
        isLinux = false;
      };
      opencode.version = "2.2.5";
    };
  };
  settings = module.programs.opencode.settings;
in {
  testOnlyBifrostMcp = {
    expr = builtins.attrNames settings.mcp.servers;
    expected = ["bifrost"];
  };
  testProductionMcpEndpoint = {
    expr = settings.mcp.servers.bifrost;
    expected = {
      type = "remote";
      url = "http://127.0.0.1:4000/mcp";
    };
  };
  testDiscoveryEnabled = {
    expr = settings.providers.bifrost.settings;
    expected = {
      baseURL = "http://127.0.0.1:4000/v1";
      apiKey = "";
      modelsDiscovery = {
        enabled = true;
        modelInfoFormat = "bifrost";
        smartModelName = true;
      };
    };
  };
  testDiscoveryPluginLoaded = {
    expr = settings.plugins;
    expected = ["opencode-models-discovery@2.2.1"];
  };
  testDiscoveryOwnsModelCatalog = {
    expr = settings.providers.bifrost ? models;
    expected = false;
  };
  testPinnedOpenCodePackage = {
    expr = module.programs.opencode.package.version;
    expected = "2.4.1";
  };
  testNativeResponsesRuntime = {
    expr = settings.providers.bifrost.package;
    expected = "@opencode/ai/providers/openai";
  };
  testDefaultModelsMatchDeployment = {
    expr = [settings.model settings.agents.build.model settings.agents.plan.model];
    expected = lib.replicate 3 "bifrost/azure/gpt-6.1-sol";
  };
  testOnlyBifrostProviderAllowed = {
    expr = settings.policies;
    expected = [
      {
        action = "provider.use";
        resource = "*";
        effect = "deny";
      }
      {
        action = "provider.use";
        resource = "bifrost";
        effect = "allow";
      }
    ];
  };
  testPreservesFormatting = {
    expr = settings.formatter.alejandra;
    expected = {
      command = ["alejandra" "$FILE"];
      extensions = [".nix"];
    };
  };
  testNoIntegrationShellWrapper = {
    expr = module ? programs.zsh.initContent;
    expected = false;
  };
}
