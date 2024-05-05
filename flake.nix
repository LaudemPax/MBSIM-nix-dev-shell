{
    inputs = {
        nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay";
        nixpkgs.follows = "nix-ros-overlay/nixpkgs";  # IMPORTANT!!!
    };
    outputs = { self, nix-ros-overlay, nixpkgs }:
        nix-ros-overlay.inputs.flake-utils.lib.eachDefaultSystem (system:
                let
                    pkgs = import nixpkgs {
                        inherit system;
                        overlays = [ nix-ros-overlay.overlays.default ];
                    };
                in {
                devShells.default = pkgs.mkShell {
                    name = "TUM MBSIM";
                    buildInputs = with pkgs.rosPackages.humble; [
                    pkgs.glibcLocales
                    pkgs.colcon
                    gazebo-ros
                    #  for iiwa
                    moveit-core
                    moveit-ros-planning
                    moveit-ros-planning-interface
                    moveit-servo
                    moveit-ros-visualization
                    moveit-visual-tools
                    ros2-control
                    rps2-controllers
                    (buildEnv { paths = [
                        desktop
                    ];})
                    ];
                };
                }
        );
    nixConfig = {
        extra-substituters = [ "https://ros.cachix.org" ];
        extra-trusted-public-keys = [ "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo=" ];
    };
}
