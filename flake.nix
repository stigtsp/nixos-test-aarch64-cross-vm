{
  description = "cross-compile the sd-image-aarch64 on x86_64-linux to aarch64-multiplatform";
  inputs = {
    nixpkgs.url = "/home/sgo/nixpkgs";
  };

  outputs = { self, nixpkgs }: {

    nixosConfigurations.cross-vm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, lib, modulesPath, ... }: {
          nixpkgs = {
            crossSystem = lib.systems.examples.aarch64-multiplatform;
          };

          imports = [ (modulesPath + "/installer/sd-card/sd-image-aarch64.nix") ];

          users.mutableUsers = false;
          users.users.root = {
            password = "root";
          };
          users.users.user = {
            password = "user";
            isNormalUser = true;
            extraGroups = [ "wheel" ];
          };
          system.stateVersion = "22.05";
        })
      ];
    };

    packages.x86_64-linux.default = self.nixosConfigurations.cross-vm.config.system.build.sdImage;
  };
}
