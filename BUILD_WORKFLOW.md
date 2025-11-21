# Build and Release Workflow

## Pre-Release Checklist

### Code Preparation
- [ ] Verify `USE_MOCK_DATA = true` in `lib/configs.dart`
- [ ] Update version in `pubspec.yaml` (format: `major.minor.patch+buildNumber`)
- [ ] Update `RELEASE_NOTES.md` with changes
- [ ] Test app on real devices (both Android and iOS if possible)
- [ ] Run `flutter analyze` to check for code issues
- [ ] Fix any warnings or errors

### Version Management
Current version: `2.2.6+28`
- Version number: `2.2.6`
- Build number: `28`

To update:
```yaml
# In pubspec.yaml
version: 2.2.7+29  # Increment for new release
```

## Android Build Workflow

### Step 1: Prepare Environment
```bash
# Ensure Flutter is up to date
flutter upgrade

# Clean previous builds
cd pawlly_flutter_app
flutter clean
flutter pub get
```

### Step 2: Build APKs
```bash
# Build split APKs (recommended - smaller file sizes)
flutter build apk --release --split-per-abi

# Or build universal APK (larger, works on all devices)
flutter build apk --release
```

### Step 3: Verify Builds
```bash
# Check output directory
ls -lh build/app/outputs/flutter-apk/

# Expected files:
# - app-armeabi-v7a-release.apk (~40-50 MB)
# - app-arm64-v8a-release.apk (~45-55 MB)
# - app-x86_64-release.apk (~45-55 MB)
```

### Step 4: Test APKs
```bash
# Install on connected device
adb devices  # Verify device is connected
adb install build/app/outputs/flutter-apk/app-arm64-v8a-release.apk

# Test all major features:
# - App launches correctly
# - Navigation works
# - Mock data loads
# - No crashes
```

### Step 5: Build App Bundle (for Play Store)
```bash
# Create AAB file
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
# Size: ~35-45 MB
```

### Step 6: Sign APKs (if needed)
If your APKs need to be manually signed:
```bash
# Create keystore (one time only)
keytool -genkey -v -keystore ~/pawlly-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias pawlly

# Sign APK
jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 \
  -keystore ~/pawlly-release-key.jks \
  build/app/outputs/flutter-apk/app-release.apk pawlly

# Verify signature
jarsigner -verify -verbose -certs \
  build/app/outputs/flutter-apk/app-release.apk
```

### Step 7: Package Release
```bash
# Create release directory
mkdir -p releases/v2.2.6+28/android

# Copy APKs
cp build/app/outputs/flutter-apk/app-*-release.apk releases/v2.2.6+28/android/

# Copy AAB
cp build/app/outputs/bundle/release/app-release.aab releases/v2.2.6+28/android/

# Create checksums
cd releases/v2.2.6+28/android
sha256sum *.apk *.aab > checksums.txt
```

## iOS Build Workflow

### Step 1: Prepare Environment (macOS only)
```bash
# Ensure Xcode is up to date
xcode-select --install

# Update CocoaPods
sudo gem install cocoapods

# Clean and prepare
cd pawlly_flutter_app
flutter clean
flutter pub get
cd ios
pod install
cd ..
```

### Step 2: Configure Signing
```bash
# Open in Xcode
open ios/Runner.xcworkspace

# In Xcode:
# 1. Select "Runner" project
# 2. Select "Runner" target
# 3. Go to "Signing & Capabilities" tab
# 4. Select your Team
# 5. Verify Bundle Identifier (e.g., com.yourcompany.pawlly)
# 6. Ensure "Automatically manage signing" is checked
```

### Step 3: Build Release
```bash
# Build iOS release
flutter build ios --release

# This compiles the app but doesn't create IPA
```

### Step 4: Create Archive (Method A - Xcode GUI)
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select target: "Any iOS Device (arm64)"
3. Menu: Product → Archive
4. Wait for archive to complete (~5-10 minutes)
5. Window → Organizer opens automatically
6. Select your archive
7. Click "Distribute App"
8. Choose distribution method:
   - **App Store Connect**: For App Store submission
   - **Ad Hoc**: For testing on registered devices
   - **Enterprise**: For internal distribution
   - **Development**: For local testing
9. Follow the wizard steps
10. Export IPA

### Step 5: Create Archive (Method B - Command Line)
```bash
# 1. Build and archive
xcodebuild -workspace ios/Runner.xcworkspace \
  -scheme Runner \
  -sdk iphoneos \
  -configuration Release \
  archive \
  -archivePath build/ios/Runner.xcarchive

# 2. Update ExportOptions.plist with your Team ID
# Edit: ios/ExportOptions.plist

# 3. Export IPA
xcodebuild -exportArchive \
  -archivePath build/ios/Runner.xcarchive \
  -exportPath build/ios/ipa \
  -exportOptionsPlist ios/ExportOptions.plist

# Output: build/ios/ipa/Runner.ipa
```

### Step 6: Verify IPA
```bash
# Check IPA was created
ls -lh build/ios/ipa/

# Expected:
# - Runner.ipa (~50-70 MB)
# - DistributionSummary.plist
# - ExportOptions.plist
# - Packaging.log

# Unzip to inspect (optional)
mkdir -p temp_ipa
unzip build/ios/ipa/Runner.ipa -d temp_ipa
ls temp_ipa/Payload/Runner.app/
```

### Step 7: Test IPA
- Install via Xcode Devices window
- Or upload to TestFlight for beta testing
- Or use Apple Configurator for Ad-Hoc distribution

### Step 8: Package Release
```bash
# Create release directory
mkdir -p releases/v2.2.6+28/ios

# Copy IPA
cp build/ios/ipa/Runner.ipa releases/v2.2.6+28/ios/pawlly-v2.2.6-28.ipa

# Create checksum
cd releases/v2.2.6+28/ios
shasum -a 256 *.ipa > checksums.txt
```

## Post-Build Tasks

### 1. Create Release Archive
```bash
cd releases/v2.2.6+28

# Create tarball
tar -czf pawlly-v2.2.6+28-android.tar.gz android/
tar -czf pawlly-v2.2.6+28-ios.tar.gz ios/

# Or create zip
zip -r pawlly-v2.2.6+28-android.zip android/
zip -r pawlly-v2.2.6+28-ios.zip ios/
```

### 2. Generate Release Notes
```bash
# Copy template
cp ../../RELEASE_NOTES.md ./RELEASE_NOTES_v2.2.6+28.md

# Add specific changes for this release
# Edit: RELEASE_NOTES_v2.2.6+28.md
```

### 3. Git Tagging
```bash
# Create annotated tag
git tag -a v2.2.6+28 -m "Release version 2.2.6 build 28"

# Push tag
git push origin v2.2.6+28

# Or create GitHub release
# Go to GitHub → Releases → Draft a new release
```

### 4. Upload to Distribution Platforms

#### Google Play Store
1. Go to https://play.google.com/console
2. Select your app
3. Production → Create new release
4. Upload `app-release.aab`
5. Add release notes
6. Review and rollout

#### Apple App Store
1. Go to https://appstoreconnect.apple.com
2. My Apps → Your App
3. + Version or Platform → iOS
4. Upload via Xcode or Transporter app
5. Complete app information
6. Submit for review

#### Direct Distribution
1. Upload APKs/IPA to your hosting service
2. Create download links
3. Share with users
4. Provide installation instructions

## Testing Checklist

### Android Testing
- [ ] Install on Android 8.0 device
- [ ] Install on Android 11+ device
- [ ] Test on phone (various screen sizes)
- [ ] Test on tablet
- [ ] Verify app icon displays correctly
- [ ] Verify splash screen
- [ ] Test all navigation
- [ ] Test mock data functionality
- [ ] Verify theme switching
- [ ] Verify language switching
- [ ] Check permissions (storage, location if used)
- [ ] Test app in background/foreground
- [ ] Test app after device restart

### iOS Testing
- [ ] Install on iOS 12 device
- [ ] Install on latest iOS version
- [ ] Test on iPhone (various sizes)
- [ ] Test on iPad
- [ ] Verify app icon displays correctly
- [ ] Verify launch screen
- [ ] Test all navigation
- [ ] Test mock data functionality
- [ ] Verify theme switching
- [ ] Verify language switching
- [ ] Check permissions (photos, location if used)
- [ ] Test app in background/foreground
- [ ] Test app after device restart

## Troubleshooting

### Android Build Issues

**Gradle build fails**:
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk --release
```

**Out of memory**:
```bash
# Increase Gradle memory in android/gradle.properties
org.gradle.jvmargs=-Xmx4096M
```

**SDK version issues**:
Check `android/app/build.gradle`:
```gradle
android {
    compileSdkVersion 34
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

### iOS Build Issues

**CocoaPods errors**:
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter build ios
```

**Signing errors**:
- Verify Team ID in Xcode
- Check certificate validity in Xcode → Preferences → Accounts
- Ensure provisioning profile is valid

**Archive fails**:
- Clean build folder: Product → Clean Build Folder (Shift+Cmd+K)
- Delete Derived Data: Xcode → Preferences → Locations → Derived Data → Delete
- Restart Xcode

## Automation

### GitHub Actions (Future Enhancement)
Create `.github/workflows/release.yml`:
```yaml
name: Build and Release

on:
  push:
    tags:
      - 'v*'

jobs:
  build-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter build apk --release --split-per-abi
      
  build-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter build ios --release --no-codesign
```

## Security Notes

### Keystore Security
- Store keystores securely (encrypted, backed up)
- Never commit keystores to git
- Use strong passwords
- Document keystore location and credentials (securely)

### API Keys
- Remove or disable any sensitive API keys in configs
- Use environment variables for keys when possible
- Review `configs.dart` before release

### Code Obfuscation (Optional)
```bash
# Build with obfuscation
flutter build apk --release --obfuscate --split-debug-info=build/debug-info
flutter build ios --release --obfuscate --split-debug-info=build/debug-info
```

## Release Checklist Summary

- [ ] Update version number
- [ ] Update release notes
- [ ] Test on devices
- [ ] Build Android APKs
- [ ] Build Android AAB
- [ ] Build iOS IPA
- [ ] Test all builds
- [ ] Create release archives
- [ ] Tag in git
- [ ] Upload to distribution platforms
- [ ] Announce release
- [ ] Monitor for crash reports

## Success Criteria

✅ All builds complete without errors
✅ APKs/IPA install successfully on test devices
✅ All major features work in mock mode
✅ No crashes during basic usage
✅ Release notes are complete
✅ Version number is updated
✅ Git is tagged
✅ Files are ready for distribution
