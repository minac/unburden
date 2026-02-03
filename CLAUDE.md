# Unburden - Project Instructions

## CI

**Local-only CI** - Run `./local-ci.sh` before commits to verify the build.

No GitHub Actions CI (intentionally avoided to save CI minutes).

## Development

- **Build**: `xcodebuild` (see `local-ci.sh`) or open `Unburden.xcodeproj` in Xcode
- **Run**: iOS Simulator or macOS via Xcode, or `./local-ci.sh` for headless build verification

## Architecture

- SwiftUI with MVVM using `@Observable`
- iCloud Documents for data persistence (with local fallback if iCloud unavailable)
- Multi-platform: iOS 17.0+ and macOS 14.0+
- Bundle ID: `app.unburden.ios`
