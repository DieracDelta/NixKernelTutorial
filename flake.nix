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
      overlays = [ rust-overlay.overlay ];
    };
    system = "x86_64-linux";
    riscvPkgs = import nixpkgs {
      localSystem = "${system}";
      crossSystem = {
        config = "riscv64-unknown-linux-gnu";
        abi = "lp64d";
      };
    };
    rust_build =
      pkgs.rust-bin.nightly."2021-05-10".default.override {
        targets = [ "riscv64gc-unknown-none-elf" ];
        extensions = [ "rust-src" "clippy" "cargo" "rustfmt-preview" ];
      };
    naersk_lib = naersk.lib."${system}".override {
      rustc = rust_build;
      cargo = rust_build;
    };
    sample_package = naersk_lib.buildPackage {
      pname = "example_kernel";
      root = ./.;
      cargoBuild = orig: "CARGO_BUILD_TARGET_DIR=$out cargo rustc  -- -Clink-arg=-nostartfiles";

    };
  in
  {
    devShell.x86_64-linux = pkgs.mkShell {
      nativeBuildInputs = [ rust_build riscvPkgs.buildPackages.gcc ];
    };
    packages.riscv64-linux.kernel = sample_package;
    packages.riscv64-linux.defaultPackage = sample_package;
  };
 
}

