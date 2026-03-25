{
  description = "Rivaldo's Unified NixOS + nix-darwin Configuration";

  nixConfig = {
    "extra-substituters" = [
      "https://nixtip.pelindungbumi.dev"
      "https://vicinae.cachix.org"
      "https://niri.cachix.org"
    ];
    "extra-trusted-public-keys" = [
      "nixtip.pelindungbumi.dev-1:2w1Zf43fmGc63a7dkAYA0PmweRCUGEYHtp+gqdRQPkY="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae.url = "github:vicinaehq/vicinae";

    vicinae-extensions.url = "github:vicinaehq/extensions";

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fff-nvim = {
      url = "github:dmtrKovalenko/fff.nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    sops-nix,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    niri,
    zen-browser,
    nvf,
    vicinae,
    vicinae-extensions,
    winapps,
    ...
  } @ inputs: let
    systems = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    nixosConfigurations = {
      thinker = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/nixos/thinker/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-bak";
              users.rivaldo = {
                imports = [
                  ./home-manager/home.nix
                  # Note: niri home module is provided via NixOS module integration
                  inputs.dankMaterialShell.homeModules.dank-material-shell
                  inputs.noctalia.homeModules.default
                  inputs.zen-browser.homeModules.beta
                  inputs.nvf.homeManagerModules.default
                  inputs.vicinae.homeManagerModules.default
                  ./home-manager/nixos/default.nix
                ];
              };
              extraSpecialArgs = {inherit inputs;};
            };
          }
        ];
      };
    };

    darwinConfigurations = {
      "Rivaldos-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/darwin/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-bak";
              users.rivaldo = {
                imports = [
                  ./home-manager/home.nix
                  inputs.nvf.homeManagerModules.default
                  ./home-manager/darwin/default.nix
                ];
              };
              extraSpecialArgs = {inherit inputs;};
            };
          }
        ];
      };

      "Rivaldos-MacBook-Air" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/darwin/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-bak";
              users.rivaldo = {
                imports = [
                  ./home-manager/home.nix
                  inputs.nvf.homeManagerModules.default
                  ./home-manager/darwin/default.nix
                ];
              };
              extraSpecialArgs = {inherit inputs;};
            };
          }
        ];
      };
    };

    nixosModules = {
      common = import ./modules/nixos/common/default.nix;
      desktop = import ./modules/nixos/desktop.nix;
      secrets = import ./modules/nixos/secrets.nix;
      virtualisation = import ./modules/nixos/virtualisation.nix;
    };

    darwinModules = {
      aerospace = import ./modules/darwin/aerospace/default.nix;
      common = import ./modules/darwin/common/default.nix;
      homebrew = import ./modules/darwin/homebrew/default.nix;
      secrets = import ./modules/darwin/secrets.nix;
    };

    homeConfigurations = {
      "rivaldo@thinker" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ./home-manager/home.nix
          # Note: niri home module is provided via NixOS module integration
          inputs.dankMaterialShell.homeModules.dank-material-shell
          inputs.noctalia.homeModules.default
          inputs.zen-browser.homeModules.beta
          inputs.nvf.homeManagerModules.default
          inputs.vicinae.homeManagerModules.default
          ./home-manager/nixos/default.nix
        ];
      };
    };
  };
}
