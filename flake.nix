{
  description = "Interactive Tmux wrapper for easier session attachment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells = rec {
        default = pkgs.mkShell {
          packages = [ pkgs.gum ];
        };
      };

      packages = let
          name = "tmux-attacher";
          src = builtins.readFile ./tmux-attacher;
          script = (pkgs.writeScriptBin name src).overrideAttrs(old: {
            buildCommand = "${old.buildCommand}\n patchShebangs $out";
          });
        in rec {
        # This approach employs a wrapper script that modifies the runtime PATH
        # passed to `tmux-attacher` before executing it.
        tmux-attacher = pkgs.symlinkJoin {
          inherit name;
          paths = [ script ] ++ [ pkgs.gum ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";
        };
        default = tmux-attacher;
      };


      apps = rec {
        tmux-attacher = flake-utils.lib.mkApp {
          drv = self.packages.${system}.tmux-attacher;
        };
        default = tmux-attacher;
      };
    }
  );
}
