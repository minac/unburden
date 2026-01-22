#!/bin/bash
set -e

echo "=== Local CI ==="
echo "Building Unburden..."

xcodebuild \
  -project Unburden.xcodeproj \
  -scheme Unburden \
  -destination 'generic/platform=iOS Simulator' \
  -configuration Debug \
  build

echo "✓ Build succeeded"
