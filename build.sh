#!/bin/bash

security list-keychains -s ios-build.keychain

rm ~/Library/MobileDevice/Provisioning\ Profiles/profile.mobileprovision
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles/
cp profile.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/

xcrun xcodebuild -project Quiz.xcodeproj -scheme Quiz -archivePath Quiz.xcarchive archive

xcrun xcodebuild -exportArchive -archivePath Quiz.xcarchive -exportPath . -exportOptionsPlist ExportOptions.plist

