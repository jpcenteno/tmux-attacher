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
      name = "tmux-attacher";
      deps = with pkgs; [ gum tmux ];
      src = builtins.readFile ./tmux-attacher;
      script = (pkgs.writeScriptBin name src).overrideAttrs(old: {
        buildCommand = "${old.buildCommand}\n patchShebangs $out";
      });
    in
    {
      devShells.default = pkgs.mkShell {
        packages = deps;
      };

      packages = {
        # This approach employs a wrapper script that modifies the runtime PATH
        # passed to `tmux-attacher` before executing it.
        ${name} = pkgs.symlinkJoin {
          inherit name;
          paths = [ script ] ++ deps;
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = "wrapProgram $out/bin/${name} --prefix PATH : $out/bin";
        };
        default = self.packages.${system}.${name};
      };


      apps = {
        ${name} = flake-utils.lib.mkApp {
          drv = self.packages.${system}.${name};
        };
        default = self.apps.${system}.${name};
      };
    }
  );
}
