{
  description = ''
    Lenny Lizowzskiy's nix repo
  '';

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
  };

  outputs = { self, nixpkgs, ... }: 
    let
      systems = [
        "x86_64-linux"
        # "i686-linux"
        # "x86_64-darwin"
        "aarch64-linux"
        # "armv6l-linux"
        # "armv7l-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

      homeManagerModules = import ./modules/home-manager {};
      nixosModules = import ./modules/nixos {};

      mkDefaultModulesOption = (mods:
        { lib, ... }:
        { imports = lib.attrsets.attrValues mods; }
      );
    in
    {
      overlays = import ./overlays {};

      homeManagerModules = homeManagerModules // (mkDefaultModulesOption homeManagerModules);
      nixosModules = nixosModules // (mkDefaultModulesOption nixosModules);

      legacyPackages = forAllSystems (system: import ./pkgs {
        pkgs = import nixpkgs { inherit system; };
      });
      packages = forAllSystems (system: (system: nixpkgs.lib.filterAttrs (_: v: nixpkgs.lib.isDerivation v) self.legacyPackages.${system}));
    };
}
