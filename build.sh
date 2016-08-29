#!/bin/sh
# Builds all targets and runs tests.

DERIVED_DATA=${1:-/tmp/LayoutKit}
echo "Derived data location: $DERIVED_DATA";

set -o pipefail &&
rm -rf $DERIVED_DATA &&
time xcodebuild clean test \
    -project ConsistencyManager.xcodeproj \
    -scheme ConsistencyManager \
    -sdk macosx10.11 \
    -derivedDataPath $DERIVED_DATA \
    | tee build.log \
    | xcpretty &&
rm -rf $DERIVED_DATA &&
time xcodebuild clean build \
    -project LayoutKit.xcodeproj \
    -scheme LayoutKitSampleApp-iOS \
    -sdk iphonesimulator9.3 \
    -derivedDataPath $DERIVED_DATA \
    -destination 'platform=iOS Simulator,name=iPhone 6,OS=8.4' \
    -destination 'platform=iOS Simulator,name=iPhone 6,OS=9.3' \
    | tee build.log \
    | xcpretty &&
cat build.log
