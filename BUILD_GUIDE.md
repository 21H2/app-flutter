# Pawlly - No Backend Version Build Guide

## Overview
This is a standalone version of the Pawlly Flutter app that works without requiring a backend server. It uses mock data stored locally instead of making API calls to a Laravel backend.

## What Changed
- **Mock Data Mode**: Added `USE_MOCK_DATA` flag in `lib/configs.dart` (currently set to `true`)
- **Mock Data Service**: Created `lib/mock_data/mock_data_service.dart` to provide local data
- **Network Layer**: Modified `lib/network/network_utils.dart` to intercept API calls and return mock data
- **Firebase**: Firebase is already disabled in the main.dart file (commented out)

## Prerequisites

### Flutter SDK
- Flutter 3.24.5 or later
- Dart SDK 3.5.4 or later

### For Android Build (APK)
- Android Studio or Android SDK command-line tools
- Java JDK 17 or later
- Android SDK Platform 34 (Android 14)
- Android SDK Build-Tools 34.0.0

### For iOS Build (IPA, not IPSW)
**Note**: IPSW files are for firmware updates. iOS apps use IPA format.
- macOS with Xcode 15.0 or later
- CocoaPods
- Valid Apple Developer Account (for distribution)

## Setup Instructions

### 1. Install Flutter
```bash
# Download Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor

# Accept Android licenses (if building for Android)
flutter doctor --android-licenses
```

### 2. Install Dependencies
```bash
cd pawlly_flutter_app
flutter pub get
```

### 3. Configure Firebase (Optional)
If you want to re-enable Firebase:
1. Uncomment Firebase initialization code in `lib/main.dart`
2. Update `firebaseConfig` in `lib/configs.dart` with your Firebase project credentials
3. Add google-services.json (Android) and GoogleService-Info.plist (iOS)

## Building for Android (APK)

### Debug APK
```bash
flutter build apk --debug
```
Output: `build/app/outputs/flutter-apk/app-debug.apk`

### Release APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Split APKs (smaller size)
```bash
flutter build apk --split-per-abi --release
```
This creates separate APKs for different CPU architectures:
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM)
- `app-x86_64-release.apk` (64-bit Intel)

### App Bundle (for Play Store)
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

## Building for iOS (IPA)

### Prerequisites
1. Open the iOS project in Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. Configure signing in Xcode:
   - Select the Runner project
   - Go to "Signing & Capabilities"
   - Select your Team
   - Update Bundle Identifier if needed

### Debug Build
```bash
flutter build ios --debug
```

### Release Build
```bash
flutter build ios --release --no-codesign
```

### Create IPA for Distribution

#### Method 1: Using Xcode
1. Build in Release mode: `flutter build ios --release`
2. Open `ios/Runner.xcworkspace` in Xcode
3. Select "Any iOS Device (arm64)" as the build target
4. Product → Archive
5. Window → Organizer
6. Select your archive and click "Distribute App"
7. Choose distribution method (App Store, Ad Hoc, Enterprise, etc.)

#### Method 2: Using Command Line
```bash
# Build release
flutter build ios --release

# Create archive
xcodebuild -workspace ios/Runner.xcworkspace \
  -scheme Runner \
  -sdk iphoneos \
  -configuration Release \
  archive -archivePath build/ios/Runner.xcarchive

# Export IPA
xcodebuild -exportArchive \
  -archivePath build/ios/Runner.xcarchive \
  -exportOptionsPlist ios/ExportOptions.plist \
  -exportPath build/ios/ipa
```

You'll need to create `ios/ExportOptions.plist` with content like:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
</dict>
</plist>
```

Replace `app-store` with `ad-hoc`, `enterprise`, or `development` as needed.

## Testing Builds

### Android
```bash
# Install on connected device or emulator
flutter install

# Or manually install APK
adb install build/app/outputs/flutter-apk/app-release.apk
```

### iOS
```bash
# Run on connected device
flutter run --release

# Or use Xcode to install the app
```

## Configuration

### Switching Between Mock and Real Backend
Edit `lib/configs.dart`:
```dart
// Use mock data (no backend required)
const bool USE_MOCK_DATA = true;

// Use real backend (requires Laravel server)
const bool USE_MOCK_DATA = false;
```

When using real backend, update:
```dart
const DOMAIN_URL = "https://your-backend-url.com";
```

### App Name and Version
Update in `pubspec.yaml`:
```yaml
name: pawlly
description: A new Flutter project.
version: 2.2.6+28  # version+buildNumber
```

### App Icons and Splash Screen
- Android icons: `android/app/src/main/res/mipmap-*/ic_launcher.png`
- iOS icons: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- Splash: Assets are in `assets/images/`

## Release Checklist

- [ ] Set `USE_MOCK_DATA = true` in `lib/configs.dart`
- [ ] Update version in `pubspec.yaml`
- [ ] Test on real devices (Android and iOS)
- [ ] Build release APK: `flutter build apk --release --split-per-abi`
- [ ] Build release IPA: Follow iOS build steps above
- [ ] Test all APK variants
- [ ] Test IPA installation
- [ ] Create release notes
- [ ] Tag the release in git
- [ ] Upload to distribution channels

## Troubleshooting

### Flutter Doctor Issues
Run `flutter doctor -v` and follow the suggestions to fix any issues.

### Android Build Failures
- Clean build: `flutter clean && flutter pub get`
- Update Gradle: Check `android/gradle/wrapper/gradle-wrapper.properties`
- Check Java version: `java --version` (should be 17+)

### iOS Build Failures
- Clean build: `flutter clean && cd ios && pod install && cd ..`
- Update CocoaPods: `sudo gem install cocoapods`
- Check Xcode: Must be version 15.0+

### App Crashes
- Check logs: `flutter logs`
- Android: `adb logcat`
- iOS: View logs in Xcode or Console app

## Mock Data Limitations

The mock data mode provides basic functionality:
- ✅ User login/registration (uses mock credentials)
- ✅ Dashboard display (empty state)
- ✅ Navigation and UI components
- ✅ Pet list (empty, can add pets locally)
- ✅ Booking list (empty)
- ❌ Real payment processing (disabled)
- ❌ Push notifications (requires Firebase)
- ❌ Social login (requires backend validation)
- ❌ Map features (requires location services)

## Distribution

### Android
- **Google Play Store**: Upload AAB file
- **Direct Distribution**: Share APK files
- **Other Stores**: Amazon Appstore, Samsung Galaxy Store, etc.

### iOS
- **App Store**: Submit via App Store Connect
- **TestFlight**: For beta testing
- **Ad-Hoc**: For limited distribution (up to 100 devices)
- **Enterprise**: For internal company distribution

## Support

For issues related to:
- **Flutter**: https://flutter.dev/community
- **Android**: https://developer.android.com/
- **iOS**: https://developer.apple.com/support/

## License

Refer to the main project license.
