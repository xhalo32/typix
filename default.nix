{
  sources ? import ./npins,
  system ? builtins.currentSystem,
  pkgs ? import sources.nixpkgs {
    inherit system;
    config = { };
    overlays = [ ];
  },
}:
{
  lib = import ./lib {
    inherit (pkgs) lib newScope;
  };
}
