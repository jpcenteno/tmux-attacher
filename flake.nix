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
      packages = rec {
        tmux-attacher = pkgs.stdenv.mkDerivation rec {
          name = "tmux-attacher";
          src = ./.;
          unpackPhase = "true"; # FIXME what does this mean?
          buildPhase = ":"; # FIXME what does this mean?
          installPhase =
            ''
              mkdir -p "$out/bin"
              cp "$src/tmux-attacher" "$out/bin/tmux-attacher"
              chmod +x "$out/bin/tmux-attacher"
            '';
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
