{
  inferTypstProjectOutput,
  lib,
  linkVirtualPaths,
  pkgs,
  typst,
  typstOptsFromArgs,
}: args @ {
  fontPaths ? [],
  forceVirtualPaths ? false,
  typstSource ? "main.typ",
  typstWatchCommand ? "typst watch",
  virtualPaths ? [],
  XDG_CACHE_HOME ? "",
  ...
}: let
  inherit (builtins) removeAttrs;
  inherit (lib) optionalString;
  inherit (lib.strings) concatStringsSep toShellVars;

  typstOptsString = args.typstOptsString or (typstOptsFromArgs args);
  typstOutput =
    args.typstOutput
    or (inferTypstProjectOutput (
      {inherit typstSource;} // args
    ));

  cleanedArgs = removeAttrs args [
    "fontPaths"
    "forceVirtualPaths"
    "scriptName"
    "text"
    "typstOpts"
    "typstOptsString"
    "typstOutput"
    "typstSource"
    "typstWatchCommand"
    "virtualPaths"
    "XDG_CACHE_HOME"
  ];
in
  pkgs.writeShellApplication (cleanedArgs
    // {
      name = args.scriptName or args.name or "typst-watch";

      runtimeInputs =
        (args.runtimeInputs or [])
        ++ [
          pkgs.coreutils
          typst
        ];

      text =
        optionalString (fontPaths != []) ''
          export TYPST_FONT_PATHS=${concatStringsSep ":" fontPaths}
        ''
        + optionalString (virtualPaths != []) (linkVirtualPaths {
          inherit virtualPaths forceVirtualPaths;
        })
        + ''

          ${toShellVars {inherit typstOutput typstSource XDG_CACHE_HOME;}}
          out=''${1:-''${typstOutput:?not defined}}
          mkdir -p "$(dirname "$out")"
          ${typstWatchCommand} ${typstOptsString} "$typstSource" "$out"
        '';
    })
