{
  inputs,
  isNixOS,
  lib,
  system,
  username,
  userfullname,
  useremail,
  ...
}: let
  mkHost = host: let
    pkgsStable = import inputs.nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
    extraSpecialArgs = {
      inherit inputs host isNixOS username userfullname useremail pkgsStable;
    };

    homeManagerImports = [
      ./${host}/home.nix # host specific home-manager configuration
      ../home
      ../options/home
      inputs.stylix.homeManagerModules.stylix
      inputs.base16.nixosModule
      inputs.nixvim.homeManagerModules.nixvim
    ];
  in
    if isNixOS
    then
      lib.nixosSystem {
        specialArgs = extraSpecialArgs;

        modules = [
          ./${host} # host specific configuration
          ./${host}/hardware-configuration.nix # host specific hardware configuration
          ../modules
          ../pkgs
          ../options/nixos
          inputs.home-manager.nixosModules.home-manager
          inputs.sops-nix.nixosModules.sops
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "back";

              inherit extraSpecialArgs;

              users.${username} = {
                imports = homeManagerImports;
                programs.home-manager.enable = true;
              };
            };
          }
          # alias for home-manager
          (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" username])
        ];
      }
    else
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit extraSpecialArgs;

        modules = homeManagerImports;
      };
in
  builtins.listToAttrs (map (host: {
    name = "${host}";
    value = mkHost host;
  }) ["pc" "laptop" "server"])
