#!/bin/sh

set -eo pipefail

cargo build
mkdir -p out/include

cargo run --bin uniffi-bindgen generate uniffi/askar.udl --language swift -o out --lib-file target/debug/libaries_askar.dylib

cp out/aries_askarFFI.h out/include/
cp out/aries_askarFFI.modulemap out/include/module.modulemap
rm -rf out/aries_askarFFI.xcframework
xcodebuild -create-xcframework \
    -library target/debug/libaries_askar.a \
    -headers out/include \
    -output out/aries_askarFFI.xcframework

# Need some workarounds to compile swift wrapper
# https://github.com/mozilla/uniffi-rs/issues/1505
# https://github.com/rust-lang/cargo/issues/11953
sed -i '' 's/ void \* _Nonnull/UnsafeMutableRawPointer/g' out/aries_askar.swift
cat > /tmp/import.txt <<EOF
#if os(macOS)
import SystemConfiguration
#endif
EOF
cat /tmp/import.txt out/aries_askar.swift > wrappers/swift/Askar/Sources/Askar/
