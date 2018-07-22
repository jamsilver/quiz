#!/bin/bash

# This should be passed in via travis encrypt mechanism.
: "${KEY_PASSWORD:?Missing KEY_PASSWORD environment variable}"

# Generate password for a temporary keychain.
KEYCHAIN_PASSWORD="`head -c32 < /dev/urandom | base64`"

# Create the keychain with a password.
security create-keychain -p "$KEYCHAIN_PASSWORD" ios-build.keychain

# Make the custom keychain default, so xcodebuild will use it for signing.
security default-keychain -s ios-build.keychain

# Unlock the keychain
security unlock-keychain -p "$KEYCHAIN_PASSWORD" ios-build.keychain

# Add certificates to keychain and allow codesign to access them.
security import ./apple.cer -k ~/Library/Keychains/ios-build.keychain -A
security import ./cert.cer -k ~/Library/Keychains/ios-build.keychain -A
security import ./key.p12 -k ~/Library/Keychains/ios-build.keychain -P "$KEY_PASSWORD" -A

security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k "$KEYCHAIN_PASSWORD" ~/Library/Keychains/ios-build.keychain

