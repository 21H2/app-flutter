# Frequently Asked Questions (FAQ)

## General Questions

### What is the "no-backend" version?
This is a modified version of the Pawlly Flutter app that works without requiring a Laravel backend server. All API calls are intercepted and served with mock data stored locally in the app.

### Why create a no-backend version?
- **Demo purposes**: Show the app without server setup
- **Offline functionality**: Test app behavior without internet
- **Development**: Work on UI/UX without backend dependencies
- **Quick testing**: Faster iteration during development
- **Standalone distribution**: Deploy without server infrastructure

### Can I switch back to using a real backend?
Yes! Simply change `USE_MOCK_DATA` from `true` to `false` in `lib/configs.dart` and configure your backend URL.

### What's the difference between IPA and IPSW?
- **IPA** (iOS App Store Package): Format for iOS apps - this is what you need
- **IPSW** (iPhone Software): Format for iOS firmware updates - NOT for apps
The correct format for iOS apps is IPA, not IPSW.

## Building & Compilation

### What are the system requirements?
**For Android builds:**
- Any OS (Windows, macOS, Linux)
- Flutter SDK 3.24.5+
- Android Studio or Android SDK
- 4GB RAM minimum (8GB recommended)
- 10GB free disk space

**For iOS builds:**
- macOS only
- Xcode 15.0+
- Flutter SDK 3.24.5+
- 8GB RAM minimum
- 20GB free disk space

### How long does building take?
- First build: 10-15 minutes (downloads dependencies)
- Subsequent builds: 2-5 minutes
- iOS archive creation: 8-12 minutes

### Why are there multiple APK files?
Flutter creates separate APKs for different CPU architectures:
- `armeabi-v7a`: 32-bit ARM devices
- `arm64-v8a`: 64-bit ARM devices (most modern Android phones)
- `x86_64`: 64-bit Intel devices (rare, mostly emulators)

This reduces app size. Users only download the APK for their device architecture.

### What's the difference between APK and AAB?
- **APK** (Android Package): Direct install format, can be shared/installed directly
- **AAB** (Android App Bundle): Play Store format, Google generates optimized APKs

Use APK for direct distribution, AAB for Google Play Store.

### Do I need a paid Apple Developer account?
- **For testing**: No, you can test on your own devices with a free account
- **For App Store**: Yes, $99/year required
- **For Ad-Hoc distribution**: Yes, paid account required
- **For Enterprise distribution**: Yes, $299/year Enterprise account required

### Can I build iOS apps on Windows or Linux?
No, iOS builds require macOS with Xcode. However, you can:
- Use a Mac
- Rent a Mac cloud service (MacinCloud, MacStadium)
- Use CI/CD services with macOS runners (GitHub Actions, Codemagic)

## Mock Data & Features

### What features work in mock mode?
✅ All UI components and navigation
✅ Mock user authentication
✅ Local pet management
✅ Theme and language switching
✅ Local data storage
✅ Basic app functionality

### What features don't work in mock mode?
❌ Real payment processing
❌ Social login (Google, Apple, Facebook)
❌ Push notifications (without Firebase setup)
❌ Cloud data sync
❌ Real backend communication
❌ Live booking confirmations

### How do I add my own mock data?
Edit `lib/mock_data/mock_data_service.dart` and add data to the `getMockResponse` function:

```dart
case 'your-endpoint':
  return {
    'status': true,
    'message': 'Success',
    'data': {
      // Your mock data here
    }
  };
```

### Can I use mock mode for production?
Not recommended. Mock mode is for:
- Demos and presentations
- Testing and development
- Offline functionality testing

For production, use a real backend with proper data validation and security.

### How is data stored in mock mode?
Data is stored locally using:
- GetStorage (key-value storage)
- Local device storage
- No cloud synchronization

Data persists between app sessions but is device-specific.

## Configuration

### How do I change the app name?
1. Update `pubspec.yaml`: `name: your_app_name`
2. Update `lib/configs.dart`: `APP_NAME = 'Your App Name'`
3. Update Android: `android/app/src/main/AndroidManifest.xml`
4. Update iOS: Open in Xcode and change Display Name

### How do I change the app icon?
1. Replace images in `android/app/src/main/res/mipmap-*/`
2. Replace images in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
3. Or use flutter_launcher_icons package for easier icon generation

### How do I update the version number?
Edit `pubspec.yaml`:
```yaml
version: 2.2.7+29  # Format: version+buildNumber
```
- Increment version (2.2.7) for new features/changes
- Increment build number (+29) for each build

### How do I enable Firebase?
1. Uncomment Firebase code in `lib/main.dart`
2. Update Firebase config in `lib/configs.dart`
3. Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
4. Rebuild the app

## Distribution

### How do I distribute Android APKs?
- **Direct**: Share APK files via email, website, or file sharing
- **Google Play**: Upload AAB file to Play Console
- **Amazon Appstore**: Upload APK
- **Samsung Galaxy Store**: Upload APK
- **Other stores**: Follow their specific requirements

### How do I distribute iOS apps?
- **TestFlight**: Upload to App Store Connect for beta testing (free)
- **App Store**: Submit through App Store Connect (requires approval)
- **Ad-Hoc**: Install on up to 100 registered devices
- **Enterprise**: Distribute internally (requires Enterprise account)

### Do I need to sign the builds?
**Android**: Optional for testing, required for Play Store
**iOS**: Always required (Xcode handles this automatically)

### Can users install the app without an app store?
**Android**: Yes, users can install APK files directly (must enable "Unknown Sources")
**iOS**: No, requires either App Store, TestFlight, or device-specific provisioning

### What's the app size?
- **Android APK**: ~40-55 MB (per architecture)
- **Android AAB**: ~35-45 MB
- **iOS IPA**: ~50-70 MB

Actual size may vary based on included assets and dependencies.

## Troubleshooting

### Flutter doctor shows errors
Run `flutter doctor --verbose` and follow the suggestions to fix each issue.

Common fixes:
```bash
flutter doctor --android-licenses  # Accept Android licenses
sudo xcode-select --switch /Applications/Xcode.app  # Fix Xcode path
```

### Build fails with "Gradle error"
```bash
cd pawlly_flutter_app
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter build apk --release
```

### Build fails with "Pod install error" (iOS)
```bash
cd pawlly_flutter_app/ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
```

### App crashes on launch
1. Check device logs: `flutter logs`
2. Ensure minimum OS version (Android 8.0+, iOS 12.0+)
3. Try debug build: `flutter run --debug`
4. Check for missing assets

### "No devices found"
```bash
# List available devices
flutter devices

# For Android, ensure USB debugging is enabled
# For iOS, ensure device is trusted

# Start an emulator
flutter emulators
flutter emulators --launch <emulator_id>
```

### Build is very slow
- Close other applications
- Disable antivirus temporarily
- Use `--no-tree-shake-icons` flag
- Increase Gradle memory (Android)
- Clear build cache: `flutter clean`

### Out of memory during build
Edit `android/gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx4096M
```

## Firebase & Backend

### Do I need Firebase for this app?
No, Firebase is disabled by default in this no-backend version. You can enable it if you want push notifications or analytics.

### Can I use my own backend?
Yes! Set `USE_MOCK_DATA = false` and configure your backend URL in `configs.dart`.

### What backend does the original app use?
Laravel (PHP framework). You'll need to set up a Laravel backend separately.

### How do push notifications work?
Push notifications require Firebase Cloud Messaging (FCM). In no-backend mode, they are disabled.

## Security & Privacy

### Is mock mode secure?
Mock mode is for testing/demos only, not production. It:
- Accepts any login credentials
- Stores data unencrypted locally
- Has no server-side validation
- Should not be used with real user data

### How do I secure the production app?
1. Use real backend with proper authentication
2. Enable SSL/TLS for API calls
3. Implement proper data validation
4. Use secure storage for sensitive data
5. Enable code obfuscation
6. Follow platform security guidelines

### Can I remove payment gateways?
Yes, if you don't need payments, you can remove the payment gateway dependencies from `pubspec.yaml` to reduce app size.

### Where are API keys stored?
In `lib/configs.dart`. For production:
- Use environment variables
- Use secure key storage
- Don't commit real keys to git
- Use platform-specific secure storage

## Updates & Maintenance

### How do I update Flutter dependencies?
```bash
flutter pub upgrade
```

Review breaking changes before upgrading major versions.

### How do I update Flutter SDK?
```bash
flutter upgrade
```

### How often should I rebuild?
- For testing: After code changes
- For release: When ready to distribute
- For Play Store: Each version update
- For App Store: Each version update

### How do I handle app updates?
- **Android**: Upload new version to Play Store
- **iOS**: Submit update through App Store Connect
- **Direct APK**: Distribute new APK file

Users will need to uninstall old version (Android) or update through store.

## Performance

### How can I reduce app size?
```bash
# Use split APKs
flutter build apk --split-per-abi

# Use obfuscation
flutter build apk --obfuscate --split-debug-info=build/debug

# Remove unused dependencies
# Edit pubspec.yaml
```

### How can I improve app performance?
- Profile with Flutter DevTools
- Optimize images (use WebP format)
- Lazy load data
- Use `const` constructors
- Minimize widget rebuilds
- Cache network images

### Does mock mode affect performance?
Mock mode is actually faster since:
- No network latency
- No API calls
- Instant responses
However, it doesn't reflect real-world performance.

## Legal & Compliance

### Can I distribute this commercially?
Check the original project's license. This repository shows technical implementation, but commercial use requires proper licensing.

### Do I need privacy policy for the app?
Yes, both Google Play and App Store require privacy policies.

### What about GDPR compliance?
If operating in EU or handling EU user data:
- Implement data deletion
- Provide data export
- Add consent mechanisms
- Update privacy policy

### App Store requirements?
- Privacy policy URL
- App description and screenshots
- Age rating
- Content guidelines compliance
- Technical requirements met

## Support

### Where can I get help?
- **Flutter issues**: https://github.com/flutter/flutter/issues
- **Flutter docs**: https://docs.flutter.dev
- **Stack Overflow**: Tag questions with `flutter`
- **Build issues**: Check BUILD_GUIDE.md troubleshooting section

### How do I report bugs?
Create an issue on the GitHub repository with:
- Description of the problem
- Steps to reproduce
- Expected vs actual behavior
- Device/OS information
- Error logs if available

### Is there a support channel?
Check the repository for:
- Issues section
- Discussions section
- Contact information
- Community channels

---

## Still Have Questions?

Check these additional resources:
- `README.md` - Project overview
- `BUILD_GUIDE.md` - Comprehensive build instructions
- `BUILD_WORKFLOW.md` - Step-by-step workflow
- `QUICKSTART.md` - Quick start guide
- `RELEASE_NOTES.md` - Release information

Or create an issue on GitHub with your question!
