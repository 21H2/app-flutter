# app-flutter

Pawlly Flutter App - No Backend Version

## Overview
This branch contains a standalone version of the Pawlly pet care app that works without requiring a backend server. The app uses mock data stored locally, making it perfect for demos, testing, or offline functionality.

## Features
- 🐕 Pet management (local storage)
- 📅 Booking interface (demo mode)
- 🛒 Shop interface (demo mode)
- 👤 User profiles (local storage)
- 🌍 Multi-language support
- 🎨 Beautiful UI with Material Design

## Quick Start

### Prerequisites
- Flutter 3.24.5 or later
- Dart SDK 3.5.4 or later
- For Android: Android Studio or Android SDK
- For iOS: macOS with Xcode 15.0+

### Installation
```bash
cd pawlly_flutter_app
flutter pub get
flutter run
```

### Build APK
```bash
flutter build apk --release --split-per-abi
```

### Build iOS (macOS only)
```bash
flutter build ios --release
```

## Documentation
- [**BUILD_GUIDE.md**](BUILD_GUIDE.md) - Comprehensive build and release instructions
- [pubspec.yaml](pawlly_flutter_app/pubspec.yaml) - Dependencies and project configuration

## Configuration
The app runs in mock data mode by default. To configure:
1. Open `pawlly_flutter_app/lib/configs.dart`
2. Set `USE_MOCK_DATA = true` for no-backend mode
3. Set `USE_MOCK_DATA = false` to connect to a real backend

## What's Different in No-Backend Version
- ✅ No Laravel backend required
- ✅ Mock data service for all API calls
- ✅ Firebase disabled by default (optional)
- ✅ Works completely offline
- ✅ Suitable for demos and testing

## Limitations
- Payment processing is disabled
- Social login requires backend
- Push notifications require Firebase configuration
- Real-time features are not available

## License
Refer to the main project license.