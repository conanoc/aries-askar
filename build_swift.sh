#!/bin/sh

set -e

rustup target add aarch64-apple-ios x86_64-apple-ios aarch64-apple-ios-sim

function copy_target() {
  local target=$1

  mkdir -p target/$target/include
  mkdir -p target/$target/lib
  cp include/*.h target/$target/include
  cp target/$target/release/libaries_askar.a target/$target/lib
}

cargo build --release --no-default-features --features mobile --target aarch64-apple-ios
copy_target aarch64-apple-ios
cargo build --release --no-default-features --features mobile --target aarch64-apple-ios-sim
copy_target aarch64-apple-ios-sim
cargo build --release --no-default-features --features mobile --target x86_64-apple-ios
copy_target x86_64-apple-ios


