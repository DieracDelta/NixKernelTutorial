{
  description = "Example for presentation";
  inputs = {
    nixpkgs.url = "nixpkgs/master";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    naersk = {
      url = "github:nmattia/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{self, nixpkgs, rust-overlay, naersk, ... }:
  let
    pkgs = import nixpkgs {
      localSystem = "${system}";
      overlays = [
        rust-overlay.overlay
        (final: prev:
        {
          qemu = prev.qemu.overrideAttrs (oldAttrs: rec {
            src = builtins.fetchurl {
              url= "https://download.qemu.org/qemu-6.0.0.tar.xz";
              sha256 = "1f9hz8rf12jm8baa7kda34yl4hyl0xh0c4ap03krfjx23i3img47";
            };
          });
        }
        )
      ];
    };
    system = "x86_64-linux";
    riscvPkgs = import nixpkgs {
      localSystem = "${system}";
      crossSystem = {
        config = "riscv64-unknown-linux-gnu";
        abi = "lp64";
      };
    };
    rust_build =
      pkgs.rust-bin.nightly."2021-05-10".default.override {
        targets = [ "riscv64imac-unknown-none-elf" ];
        extensions = [ "rust-src" "clippy" "cargo" "rustfmt-preview" ];
      };
      naersk_lib = naersk.lib."${system}".override {
        rustc = rust_build;
        cargo = rust_build;
      };
      sample_package = naersk_lib.buildPackage {
        pname = "example_kernel";
        root = ./.;
        cargoBuild = orig: "CARGO_BUILD_TARGET_DIR=$out cargo rustc --release --target=\"riscv64imac-unknown-none-elf\" -- -Clink-arg=-Tlinker.ld -Ccode-model=medium";
      };
  in
  {
    devShell.x86_64-linux = pkgs.mkShell {
      nativeBuildInputs = [ pkgs.qemu rust_build riscvPkgs.buildPackages.gcc riscvPkgs.buildPackages.gdb];
    };
    packages.riscv64-linux.kernel = sample_package;
    packages.riscv64-linux.defaultPackage = sample_package;
    apps.x86_64-linux.toy_kernel = {
      type = "app";
      program = "${pkgs.qemu}/bin/qemu-system-riscv64 -bios ${sample_package}/riscv64imac-unknown-none-elf/release/nix_example_kernel -machine sifive_u";
    };
    defaultApp.x86_64-linux = self.apps.x86_64-linux.toy_kernel;
  };
}

