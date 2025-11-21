# Quick Start Guide - Pawlly No-Backend Version

This guide will help you quickly build and test the Pawlly app without a backend server.

## Prerequisites Check

Before you begin, ensure you have:

- ✅ **Flutter SDK** 3.24.5 or later
- ✅ **Dart SDK** 3.5.4 or later (comes with Flutter)
- ✅ For Android: Android Studio or Android SDK tools
- ✅ For iOS: macOS with Xcode 15.0+

## 5-Minute Setup

### Step 1: Verify Flutter Installation

```bash
flutter doctor
```

Expected output should show:
- ✓ Flutter (Channel stable, version 3.24.5 or later)
- ✓ Android toolchain (if building for Android)
- ✓ Xcode (if building for iOS on macOS)

If you see ✗ marks, run:
```bash
flutter doctor --android-licenses  # Accept Android licenses
```

### Step 2: Get Dependencies

```bash
cd pawlly_flutter_app
flutter pub get
```

This downloads all required packages (~2-3 minutes).

### Step 3: Run the App

```bash
# Connect a device or start an emulator, then:
flutter run
```

The app will compile and launch in debug mode (~2-3 minutes first time).

## Building Release Versions

### Android APK (One Command)

```bash
./build.sh android release
```

Or manually:
```bash
cd pawlly_flutter_app
flutter build apk --release --split-per-abi
```

**Outputs**: `build/app/outputs/flutter-apk/`
- `app-armeabi-v7a-release.apk` (~45 MB)
- `app-arm64-v8a-release.apk` (~50 MB)  
- `app-x86_64-release.apk` (~50 MB)

### iOS IPA (macOS Only)

```bash
./build.sh ios release
```

Then in Xcode:
1. Open `pawlly_flutter_app/ios/Runner.xcworkspace`
2. Product → Archive
3. Distribute App → Export IPA

## Testing Your Build

### Android
```bash
# Install on connected device
adb install pawlly_flutter_app/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

### iOS
- Use Xcode to install on a connected device
- Or upload to TestFlight for testing

## Common Issues & Quick Fixes

### "Flutter command not found"
```bash
# Add Flutter to PATH
export PATH="$PATH:/path/to/flutter/bin"
# Add this line to ~/.bashrc or ~/.zshrc for permanent fix
```

### "Gradle build failed" (Android)
```bash
cd pawlly_flutter_app
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter build apk --release
```

### "Pod install failed" (iOS)
```bash
cd pawlly_flutter_app/ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
```

### "No devices found"
```bash
# Check connected devices
flutter devices

# Start Android emulator
flutter emulators --launch <emulator_id>

# Or connect a physical device with USB debugging enabled
```

## Quick Feature Test

After installing the app, test these features:

1. ✅ **Launch**: App opens without crashing
2. ✅ **Login**: Enter any email/password (mock mode accepts anything)
3. ✅ **Navigation**: Tap through different tabs
4. ✅ **Theme**: Toggle dark/light mode
5. ✅ **Language**: Change language (Settings)
6. ✅ **Add Pet**: Try adding a pet (stored locally)

## File Locations

- **Source code**: `pawlly_flutter_app/lib/`
- **Configuration**: `pawlly_flutter_app/lib/configs.dart`
- **Mock data**: `pawlly_flutter_app/lib/mock_data/`
- **Android builds**: `pawlly_flutter_app/build/app/outputs/`
- **iOS builds**: `pawlly_flutter_app/build/ios/`

## Configuration Toggle

To switch between mock and real backend:

```dart
// File: pawlly_flutter_app/lib/configs.dart

// For no-backend mode (default)
const bool USE_MOCK_DATA = true;

// For real backend
const bool USE_MOCK_DATA = false;
const DOMAIN_URL = "https://your-backend-url.com";
```

## Build Script Usage

The included build script automates the build process:

```bash
# Build Android release
./build.sh android release

# Build iOS release  
./build.sh ios release

# Build both platforms
./build.sh both release

# Build debug version
./build.sh android debug
```

## Performance Tips

### Faster Builds
- Use `--split-per-abi` for smaller APKs
- Clean build folder if facing issues: `flutter clean`
- Close other applications during build

### Smaller App Size
```bash
# Build with obfuscation (Android)
flutter build apk --release --split-per-abi --obfuscate --split-debug-info=build/debug-info

# Build with size optimization
flutter build apk --release --target-platform android-arm64 --analyze-size
```

## Getting Help

- **Build Issues**: See `BUILD_GUIDE.md` → Troubleshooting section
- **Workflow Questions**: See `BUILD_WORKFLOW.md`
- **Feature Documentation**: See `RELEASE_NOTES.md`
- **Flutter Docs**: https://docs.flutter.dev

## Next Steps

After successfully building:

1. 📱 **Test thoroughly** on multiple devices
2. 📋 **Review** `RELEASE_NOTES.md` for limitations
3. 📦 **Package** builds following `BUILD_WORKFLOW.md`
4. 🚀 **Distribute** via your chosen method
5. 📊 **Monitor** user feedback

## Quick Command Reference

```bash
# Check Flutter
flutter doctor -v

# Get dependencies
flutter pub get

# Run app
flutter run

# Build APK
flutter build apk --release --split-per-abi

# Build AAB (Play Store)
flutter build appbundle --release

# Build iOS
flutter build ios --release

# Clean build
flutter clean

# Analyze code
flutter analyze

# Run tests
flutter test

# List devices
flutter devices

# View logs
flutter logs
```

## Success Indicators

You'll know the build succeeded when:

✅ No errors in build output
✅ APK/IPA files created in build directory
✅ File sizes are reasonable (40-60 MB for APK, 50-70 MB for IPA)
✅ App installs on test device
✅ App launches without crashing
✅ Mock data mode is working (can "login" with any credentials)

## Time Estimates

- **First build**: 10-15 minutes (downloads dependencies)
- **Subsequent builds**: 2-5 minutes
- **Clean build**: 5-8 minutes
- **iOS archive**: 8-12 minutes

---

**Ready to build?** Start with Step 1 above, or jump straight to building with:
```bash
./build.sh both release
```

For detailed information, refer to:
- `BUILD_GUIDE.md` - Comprehensive build instructions
- `BUILD_WORKFLOW.md` - Step-by-step workflow
- `RELEASE_NOTES.md` - Release information
