{inputs, ...}: {
  repository.features = [
    {
      nixos = {
        targets = ["*"];
        module = {pkgs, ...}: {
          environment.systemPackages = [pkgs.google-chrome];
        };
      };
      homeManager = {
        targets = ["*"];
        module = {
          lib,
          pkgs,
          ...
        }: let
          essentialPin = container: id: url: position: {
            inherit container id url position;
            isEssential = true;
          };
          commonSearch = {
            force = true;
            default = "google";
            engines = {
              google = {
                name = "Google";
                urls = [{template = "https://www.google.com/search?q={searchTerms}";}];
              };
              github = {
                name = "GitHub";
                definedAliases = ["@gh"];
                urls = [{template = "https://github.com/search?q={searchTerms}";}];
              };
              gmail = {
                name = "Gmail";
                definedAliases = ["@gmail"];
                urls = [{template = "https://mail.google.com/mail/ca/u/0/#apps/{searchTerms}";}];
              };
              gitlab = {
                name = "GitLab";
                definedAliases = ["@gl"];
                urls = [{template = "https://gitlab.at.rws.nl/data_en_ai_lab?filter={searchTerms}";}];
              };
            };
          };
          profileSettings = {
            "zen.welcome-screen.seen" = true;
            "browser.aboutwelcome.enabled" = false;
            "browser.startup.homepage_override.mstone" = "ignore";
            "browser.shell.checkDefaultBrowser" = false;
            "signon.rememberSignons" = false;
            "signon.autofillForms" = false;
            "extensions.formautofill.addresses.enabled" = false;
            "extensions.formautofill.creditCards.enabled" = false;
            "browser.formfill.enable" = false;
            "zen.view.show-newtab-button-top" = false;
            "zen.workspaces.wrap-around-navigation" = false;
            "zen.workspaces.swipe-actions.edge-actions" = true;
            "zen.library.enabled" = true;
            "zen.library.last-tab" = "media";
          };
        in {
          imports = [inputs.zen-browser.homeModules.beta];
          programs.zen-browser = {
            enable = true;
            setAsDefaultBrowser = true;
            nativeMessagingHosts = [pkgs._1password-gui];
            policies.ExtensionSettings = {
              "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
                installation_mode = "force_installed";
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
              };
              "uBlock0@raymondhill.net" = {
                installation_mode = "force_installed";
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              };
            };
            profiles = {
              personal = {
                id = 0;
                isDefault = true;
                containersForce = true;
                containers.Personal = {
                  id = 1;
                  color = "purple";
                  icon = "fingerprint";
                };
                containers.Work = {
                  id = 2;
                  color = "blue";
                  icon = "briefcase";
                };
                search = commonSearch;
                settings = profileSettings;
                spacesForce = true;
                spaces.Personal = {
                  id = "51e22ca9-d2c7-4b3b-8c8b-bc5534874704";
                  container = 1;
                  position = 1000;
                  icon = "chrome://browser/skin/zen-icons/selectable/planet.svg";
                  theme = {
                    colors = [
                      {
                        red = 237;
                        green = 199;
                        blue = 120;
                        algorithm = "complementary";
                        primary = true;
                        lightness = 70;
                        position = {
                          x = 215;
                          y = 210;
                        };
                        type = "explicit-lightness";
                      }
                      {
                        red = 121;
                        green = 158;
                        blue = 236;
                        algorithm = "complementary";
                        primary = false;
                        lightness = 70;
                        position = {
                          x = 143;
                          y = 148;
                        };
                        type = "explicit-lightness";
                      }
                    ];
                    opacity = 0.8;
                  };
                  pins = {
                    Gmail = essentialPin 1 "0f2c7c36-d59e-4428-9cc4-5af0e77cd709" "https://mail.google.com/mail/u/0/" 1;
                    YouTube = essentialPin 1 "a0fcdf85-cdc4-43d7-a5b9-7a9969b9c1ce" "https://yt.intranet.seleneblok.com/" 2;
                    YouTubeMusic = essentialPin 1 "b1d75f20-6812-4cda-a26c-cba8ba7a39b4" "https://music.youtube.com/" 3;
                    UniFi = essentialPin 1 "c2ef1653-3aae-4fa0-8ad8-4c0bf4ccd1d8" "https://unifi.seleneblok.com/network/default/devices" 4;
                    WhatsApp = essentialPin 1 "d3102754-4c39-4e52-80ef-8498e92a89db" "https://web.whatsapp.com/" 5;
                    Komodo = essentialPin 1 "e442a785-1e2f-4e72-b863-5ff84ac572f4" "https://komodo.intranet.seleneblok.com/" 6;
                    Dashboard = essentialPin 1 "f5b4d936-91a0-4383-9b1d-4f69c7f56abf" "http://10.10.40.10:8080/Dashboard" 7;
                  };
                };
                spaces.Work = {
                  id = "c547e4c6-68c8-49d1-b44d-961608869c91";
                  container = 2;
                  position = 2000;
                  icon = "chrome://browser/skin/zen-icons/selectable/flag.svg";
                  theme = {
                    colors = [
                      {
                        red = 156;
                        green = 175;
                        blue = 252;
                        algorithm = "complementary";
                        primary = true;
                        lightness = 80;
                        position = {
                          x = 172;
                          y = 171;
                        };
                        type = "explicit-lightness";
                      }
                      {
                        red = 253;
                        green = 235;
                        blue = 155;
                        algorithm = "complementary";
                        primary = false;
                        lightness = 80;
                        position = {
                          x = 186;
                          y = 187;
                        };
                        type = "explicit-lightness";
                      }
                    ];
                    opacity = 0.8;
                  };
                  pins = {
                    GitLab = essentialPin 2 "1c914e22-b77f-49b3-b67f-8c0ce4a84c4f" "https://gitlab.at.rws.nl/data_en_ai_lab/projects/rws-webui/-/boards" 1;
                    AzurePortal = essentialPin 2 "2d02f353-208d-416e-9ce2-27c7e2d6e8c0" "https://portal.azure.com/#home" 2;
                    SharePoint = essentialPin 2 "3e135e65-77ca-4f01-9a33-732de8f3c83a" "https://rijkswaterstaat-my.sharepoint.com/" 3;
                    Microsoft365 = essentialPin 2 "4f246f76-bcea-4275-9e11-c93a93c57ee6" "https://m365.cloud.microsoft/apps" 4;
                    Werkplek = essentialPin 2 "51038487-7dd6-4859-9ac4-7d19c9443e59" "https://werkplek.rws.nl/" 5;
                    AzureDevOps = essentialPin 2 "62149598-f8c7-4a03-837e-5f27c7ec2dd6" "https://dev.azure.com/Rijkswaterstaat/DatalabOps/_git/" 6;
                    Teams = essentialPin 2 "7325a6a9-1bad-48e4-b4ca-6493bdb0b8a2" "https://teams.cloud.microsoft/" 7;
                  };
                  routes = {
                    gitlab.reference = "gitlab.at.rws.nl";
                    azure.reference = "https?://.*\\.azure\\.com";
                    azure.matchType = "regex";
                  };
                };
              };
            };
          };
          home.activation.defaultBrowser = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
            lib.hm.dag.entryAfter ["linkGeneration"] ''
              ${pkgs.duti}/bin/duti -s app.zen-browser.zen all
            ''
          );
        };
      };
    }
  ];
}
