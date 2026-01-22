# Unburden - Project Instructions

## CI

**Local-only CI** - Run `./local-ci.sh` before commits to verify the build.

No GitHub Actions CI (intentionally avoided to save CI minutes).

## Development

- **Build**: `swift build` or open `Unburden.xcodeproj` in Xcode
- **Run**: iOS Simulator via Xcode or `./local-ci.sh` for headless build verification

## Architecture

- SwiftUI with MVVM using `@Observable`
- iCloud Documents for data persistence
- Target: iOS 17.0+
