#!/usr/bin/env bash

set -e

BASE_PWD="$PWD"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
OUTPUT_DIR=$( mktemp -d )
COMMON_SETUP="-workspace ${SCRIPT_DIR}/../TakeASelfie.xcworkspace -scheme TakeASelfie -configuration Release -quiet SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES"

# macOS Catalyst
DERIVED_DATA_PATH=$( mktemp -d )
xcrun xcodebuild build \
	$COMMON_SETUP \
	-derivedDataPath "${DERIVED_DATA_PATH}" \
	-destination 'generic/platform=macOS,variant=Mac Catalyst'

mkdir -p "${OUTPUT_DIR}/maccatalyst"
cp -r "${DERIVED_DATA_PATH}/Build/Products/Release-maccatalyst/TakeASelfie.framework" "${OUTPUT_DIR}/maccatalyst"
rm -rf "${DERIVED_DATA_PATH}"

# iOS
DERIVED_DATA_PATH=$( mktemp -d )
xcrun xcodebuild build \
	$COMMON_SETUP \
	-derivedDataPath "${DERIVED_DATA_PATH}" \
	-destination 'generic/platform=iOS'

mkdir -p "${OUTPUT_DIR}/iphoneos"
cp -r "${DERIVED_DATA_PATH}/Build/Products/Release-iphoneos/TakeASelfie.framework" "${OUTPUT_DIR}/iphoneos"
rm -rf "${DERIVED_DATA_PATH}"

# iOS Simulator
DERIVED_DATA_PATH=$( mktemp -d )
xcrun xcodebuild build \
	$COMMON_SETUP \
	-derivedDataPath "${DERIVED_DATA_PATH}" \
	-destination 'generic/platform=iOS Simulator'

mkdir -p "${OUTPUT_DIR}/iphonesimulator"
cp -r "${DERIVED_DATA_PATH}/Build/Products/Release-iphonesimulator/TakeASelfie.framework" "${OUTPUT_DIR}/iphonesimulator"
rm -rf "${DERIVED_DATA_PATH}"

# XCFRAMEWORK
xcrun xcodebuild -create-xcframework \
	-framework "${OUTPUT_DIR}/iphoneos/TakeASelfie.framework" \
	-framework "${OUTPUT_DIR}/iphonesimulator/TakeASelfie.framework" \
	-framework "${OUTPUT_DIR}/maccatalyst/TakeASelfie.framework" \
	-output ${OUTPUT_DIR}/TakeASelfie.xcframework

ditto -c -k --keepParent ${OUTPUT_DIR}/TakeASelfie.xcframework TakeASelfie.xcframework.zip

echo "✔️ TakeASelfie.xcframework"

rm -rf ${OUTPUT_DIR}

cd ${BASE_PWD}
