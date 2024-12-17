{
  description = "Nix development environment of CargOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    riscv-gnu-toolchain = {
      url = "github:carg-os/riscv-gnu-toolchain";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, riscv-gnu-toolchain, ... }@inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    devShells."${system}".default = pkgs.mkShell {
      packages = with pkgs; [
        clang
        cmake
        qemu
        riscv-gnu-toolchain.packages."${system}".default
      ];
    };
  };
}
