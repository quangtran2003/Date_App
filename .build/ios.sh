#!/bin/bash
set -e

cd ..

VERSION=$(grep 'version:' pubspec.yaml | awk '{print $2}')
NUMBER=$(grep 'number:' pubspec.yaml | awk '{print $2}')
VERSION_NUMBER=$(echo $VERSION | cut -d'+' -f1)
BUILD_NUMBER=$(echo $NUMBER | cut -d'+' -f2)

cd ios

agvtool new-marketing-version $VERSION_NUMBER
agvtool new-version -all $BUILD_NUMBER


cd ..

fvm flutter build ipa --target lib/main_dev.dart --release --export-method ad-hoc


APP_BUNDLE_PATH="./build/ios/ipa/Easy Date.ipa"
firebase appdistribution:distribute "$APP_BUNDLE_PATH" \
    --app  1:788899673990:ios:1346a9e9901894adce1e07   \
    --release-notes "Version: $VERSION - $(date "+%Y-%m-%d %H:%M:%S")" \
    --testers "" \
    --groups "tester"
echo '-------------------'
echo 'Build iOS done'