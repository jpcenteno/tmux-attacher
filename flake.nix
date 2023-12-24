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

      packages = rec {
        # This approach employs a wrapper script that modifies the runtime PATH
        # passed to `tmux-attacher` before executing it.
        tmux-attacher = pkgs.writeScriptBin "tmux-attacher" ''
          export PATH="${pkgs.lib.makeBinPath [ pkgs.gum ]}:$PATH"
          ${./tmux-attacher}
        '';

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
