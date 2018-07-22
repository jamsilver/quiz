#!/bin/bash

security list-keychains -s ios-build.keychain

rm ~/Library/MobileDevice/Provisioning\ Profiles/profile.mobileprovision
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles/
cp profile.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/

mkdir build

xcrun xcodebuild -project Quiz.xcodeproj -scheme Quiz -archivePath build/Quiz.xcarchive archive

xcrun xcodebuild -exportArchive -archivePath build/Quiz.xcarchive -exportPath build -exportOptionsPlist ExportOptions.plist

