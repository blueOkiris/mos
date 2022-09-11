# Modular OS (MOS)

## Description

A 64-bit Desktop OS with a exokernel-like architecture, allowing many parts of the OS to be hot swapped or replaced.

## Building

1. `git submodule update --init --recursive`
2. Install and set up [rustup](https://www.rust-lang.org/tools/install)
    1. Update rustup via `rustup update`
    2. Install the platform: `rustup target add x86_64-unknwon-none`
    3. Install the nightly toolchain for it: `rustup toolchain install nightly --target=x86_64-unknown-none`
3. Install `nasm` and `make`
4. Build with `make`

