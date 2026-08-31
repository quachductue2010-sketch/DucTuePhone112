#!/bin/bash
set -e
rm -rf build Payload DucTuePhone101.ipa
xcodebuild \
  -project DucTuePhone101.xcodeproj \
  -scheme DucTuePhone101 \
  -configuration Release \
  -sdk iphoneos \
  -derivedDataPath build \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY=""
mkdir -p Payload
cp -R build/Build/Products/Release-iphoneos/DucTuePhone101.app Payload/
zip -r DucTuePhone101.ipa Payload
printf '\nDone: %s/DucTuePhone101.ipa\n' "$PWD"
