{ pkgs, lib, stdenv, sources, ... }:

let
  updatedPlugins = sources.micro-updated-plugins;
  jabbalaciRepo = sources.micro-jabbalaci-plugins;

  mkMicroPlugin = 
    {
      name ? "",
      version ? src.date,
      src ? updatedPlugins,
      root ? ".",
      meta ? null
    }: 
    stdenv.mkDerivation {
      pname = "microplugins-${name}";
      version = version;
      src = src;
      installPhase = ''
        mkdir $out
        cp -a $src/${root}/. $out
      '';
      meta = meta;
    };
in
{
  editorconfig = mkMicroPlugin {
    name = "editorconfig";
    root = /editorconfig-micro;
  };

  filemanager = mkMicroPlugin {
    name = "filemanager";
    src = sources.micro-X_Ryl669-plugins;
    root = /filemanager-micro;
  };

  fzf = mkMicroPlugin {
    name = "fzf";
    root = /fzf;
  };

  go = mkMicroPlugin {
    name = "go";
    root = /go-plugin;
  };

  join-lines = mkMicroPlugin {
    name = "join-lines";
    root = /join-lines-plugin;
  };

  manipulator = mkMicroPlugin {
    name = "manipulator";
    root = /manipulator-plugin;
  };

  crystal = mkMicroPlugin {
    name = "crystal";
    root = /micro-crystal;
  };

  fish = mkMicroPlugin {
    name = "fish";
    root = /micro-fish-plugin;
  };

  misspell = mkMicroPlugin {
    name = "misspell";
    root = /micro-misspell-plugin;
  };

  pony = mkMicroPlugin {
    name = "pony";
    root = /micro-pony-crystal;
  };

  snippets = mkMicroPlugin {
    name = "snippets";
    root = /micro-snippets-plugin;
    meta = {
      broken = true;
    };
  };

  wc = mkMicroPlugin {
    name = "wc";
    root = /micro-wc-plugin;
    meta = {
      broken = true;
    };
  };

  selto = mkMicroPlugin {
    name = "selto";
    src = sources.micro-selto-plugin;
  };

  align = mkMicroPlugin {
    name = "align";
    src = sources.micro-align-plugin;
  };

  capitalizer = mkMicroPlugin {
    name = "capitalizer";
    src = sources.micro-capitalizer-plugin;
  };

  gz = mkMicroPlugin {
    name = "gz";
    src = sources.micro-gz-plugin;
  };

  tnsl = mkMicroPlugin {
    name = "tnsl";
    src = sources.micro-tnsl-plugin;
  };

  cheat = mkMicroPlugin {
    name = "cheat";
    src = sources.micro-cheat-plugin;
  };

  palettero = mkMicroPlugin {
    name = "palettero";
    src = sources.micro-palettero-plugin;
  };

  autofmt = mkMicroPlugin {
    name = "autofmt";
    src = jabbalaciRepo;
    root = /autofmt";
  };

  closeOthers = mkMicroPlugin {
    name = "closeOthers";
    src = jabbalaciRepo;
    root = /closeOthers;
  };

  closeRunner = mkMicroPlugin {
    name = "closeRunner";
    src = jabbalaciRepo;
    root = /closeRunner;
  };

  copyPathToClipboard = mkMicroPlugin {
    name = "copyPathToClipboard";
    src = jabbalaciRepo;
    root = /copyPathToClipboard;
  };

  jumpToLine = mkMicroPlugin {
    name = "jumpToLine";
    src = jabbalaciRepo;
    root = /jumpToLine;
  };

  markdownPreview = mkMicroPlugin {
    name = "markdownPreview";
    src = jabbalaciRepo;
    root = /markdownPreview;
  };

  mypy = mkMicroPlugin {
    name = "mypy";
    src = jabbalaciRepo;
    root = /mypy;
  };

  replace = mkMicroPlugin {
    name = "replace";
    src = jabbalaciRepo;
    root = /replace;
  };

  toggle = mkMicroPlugin {
    name = "toggle";
    src = jabbalaciRepo;
    root = /toggle;
  };

  vim = mkMicroPlugin {
    name = "vim";
    src = jabbalaciRepo;
    root = /vim;
  };

  acme = mkMicroPlugin {
    name = "acme";
    src = sources.micro-acme-plugin;
  };

  nelua = mkMicroPlugin {
    name = "nelua";
    src = sources.micro-nelua-plugin;
  };
}
