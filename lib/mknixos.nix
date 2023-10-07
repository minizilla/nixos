{ stateVersion
, nixpkgs
, home-manager
, ...
}: nixosConfigurations:

# nixosConfigurations = {
#   ${hostname} = {
#     system = ${system};
#     machine = ${machine};
#     user = ${user};
#     hashedPassword = ${hashedPassword};
#     resolution = { x = ${x}; y = ${y}; };
#     dpi = ${dpi};
#   };
# };

builtins.mapAttrs
  (hostname: settings: nixpkgs.lib.nixosSystem {
    inherit (settings) system;
    specialArgs = {
      inherit stateVersion hostname;
      inherit (settings) user hashedPassword resolution dpi;
    };
    modules = [
      home-manager.nixosModules.default

      ({ config, lib, pkgs, ... }: {
        imports = import ../conf;
        nixpkgs.overlays = [ (import ./overlays.nix) ];
        nix.registry.nixpkgs.flake = nixpkgs;
        nix.nixPath = [ "nixpkgs=flake:nixpkgs" ];
      })

      ../machines/${settings.machine}
    ];
  })
  nixosConfigurations
