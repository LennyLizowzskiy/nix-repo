{ pkgs, ... }@args:

(pkgs.callPackage ./generated.nix {}) // {
  
}