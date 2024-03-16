{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: flake-utils.lib.eachSystem [ "x86_64-linux" ] (system: 
    let 
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in 
      {
        packages = {
          rapidcheckPatched = pkgs.callPackage ./rapidcheckPatched.nix { };
          rapidcheckFixed = pkgs.symlinkJoin {
            name = "rapidcheckFixed";
            paths = (with pkgs; [ rapidcheck.out rapidcheck.dev ]);
          };
        };

        devShells = {
          default = pkgs.mkShell {
            buildInputs = (with pkgs; [
              rapidcheck
              cmakeCurses
            ]);
          };

          fixed = pkgs.mkShell {
            buildInputs = (with pkgs; [
              self.packages.${system}.rapidcheckFixed
              cmakeCurses
            ]);
          };
        };
      }
  );
}
