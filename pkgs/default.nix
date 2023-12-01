{ pkgs, ... }:

with pkgs;

let
  callPackageWithSources = (p: 
    callPackage p {
      sources = callPackage ./sources {}; 
    }
  )
in
{
  microPlugins = callPackageWithSources ./plugins/micro;
  liteXlPlugins = callPackageWithSources ./plugins/lite-xl;
}
