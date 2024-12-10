{
  lib,
  config,
  ...
}: {
  options.nixos = {
    amdgpu = {
      enable = lib.mkEnableOption "AMD gpu";
    };
    nvidia = {
      drivers = {
        enable = lib.mkEnableOption "Nvidia drivers";
        version = lib.mkOption {
          type = lib.types.enum ["latest" "stable" "production" "beta"];
          default = "latest";
        };
      };
    };

    drives = lib.mkOption {
      type = with lib.types;
        listOf (
          submodule {
            options = {
              label = lib.mkOption {
                type = str;
                description = "Drive label";
              };
              mountpoint = lib.mkOption {
                type = str;
                description = "Drive mountpoint";
              };
              fstype = lib.mkOption {
                type = str;
                description = "Drive filesystem type";
              };
            };
          }
        );
      default = [];
      description = "Optional drives";
    };
  };
}
