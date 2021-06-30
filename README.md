[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

# usage

Example "hello world" kernel targeting the riscv sifive_u machine on qemu. Wrapped in a Nix Flake. Meant as proof of concept.

Usage:

```sh
nix flake show
nix run github:DieracDelta/NixKernelTutorial
```

A writeup is included [here](https://justin.restivo.me/posts/2021-05-30-nix-rust-riscv-toy-kernel.html) that walks through the code.
