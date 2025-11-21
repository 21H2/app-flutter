#!/bin/bash
# Build script for Pawlly No-Backend Version
# Usage: ./build.sh [android|ios|both] [debug|release]

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
PLATFORM="${1:-both}"
BUILD_MODE="${2:-release}"
APP_DIR="pawlly_flutter_app"

echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}Pawlly No-Backend Build Script${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}Error: Flutter is not installed or not in PATH${NC}"
    echo "Please install Flutter from https://flutter.dev"
    exit 1
fi

# Check Flutter version
echo -e "${YELLOW}Checking Flutter version...${NC}"
flutter --version

# Navigate to app directory
if [ ! -d "$APP_DIR" ]; then
    echo -e "${RED}Error: $APP_DIR directory not found${NC}"
    exit 1
fi

cd "$APP_DIR"

# Check if USE_MOCK_DATA is enabled (robust pattern matching)
if grep -q -E "const\s+bool\s+USE_MOCK_DATA\s*=\s*true" lib/configs.dart; then
    echo -e "${GREEN}✓ Mock data mode is enabled${NC}"
else
    echo -e "${YELLOW}⚠ Warning: Mock data mode is not enabled${NC}"
    echo "Edit lib/configs.dart and set USE_MOCK_DATA = true"
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Clean and get dependencies
echo -e "${YELLOW}Cleaning previous builds...${NC}"
flutter clean

echo -e "${YELLOW}Getting dependencies...${NC}"
flutter pub get

# Run flutter analyze
echo -e "${YELLOW}Running code analysis...${NC}"
if flutter analyze; then
    echo -e "${GREEN}✓ No analysis issues found${NC}"
else
    echo -e "${RED}⚠ Analysis found some issues${NC}"
    read -p "Continue with build? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Function to build Android
build_android() {
    echo -e "${GREEN}======================================${NC}"
    echo -e "${GREEN}Building for Android${NC}"
    echo -e "${GREEN}======================================${NC}"
    
    if [ "$BUILD_MODE" == "release" ]; then
        echo -e "${YELLOW}Building release APKs (split by ABI)...${NC}"
        flutter build apk --release --split-per-abi
        
        echo ""
        echo -e "${GREEN}Build complete!${NC}"
        echo -e "APKs created in: ${YELLOW}build/app/outputs/flutter-apk/${NC}"
        ls -lh build/app/outputs/flutter-apk/*.apk
        
        # Calculate checksums
        echo ""
        echo -e "${YELLOW}Generating checksums...${NC}"
        cd build/app/outputs/flutter-apk/
        sha256sum *.apk > checksums.txt
        echo -e "${GREEN}Checksums saved to checksums.txt${NC}"
        cd ../../../../
        
        # Build App Bundle
        echo ""
        echo -e "${YELLOW}Building App Bundle for Play Store...${NC}"
        flutter build appbundle --release
        echo -e "${GREEN}App Bundle created: ${YELLOW}build/app/outputs/bundle/release/app-release.aab${NC}"
        
    else
        echo -e "${YELLOW}Building debug APK...${NC}"
        flutter build apk --debug
        echo -e "${GREEN}Debug APK created: ${YELLOW}build/app/outputs/flutter-apk/app-debug.apk${NC}"
    fi
}

# Function to build iOS
build_ios() {
    echo -e "${GREEN}======================================${NC}"
    echo -e "${GREEN}Building for iOS${NC}"
    echo -e "${GREEN}======================================${NC}"
    
    # Check if running on macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        echo -e "${RED}Error: iOS builds require macOS${NC}"
        return 1
    fi
    
    # Check if Xcode is installed
    if ! command -v xcodebuild &> /dev/null; then
        echo -e "${RED}Error: Xcode is not installed${NC}"
        return 1
    fi
    
    # Update CocoaPods
    echo -e "${YELLOW}Updating CocoaPods...${NC}"
    cd ios
    pod install
    cd ..
    
    if [ "$BUILD_MODE" == "release" ]; then
        echo -e "${YELLOW}Building iOS release...${NC}"
        flutter build ios --release
        
        echo ""
        echo -e "${GREEN}iOS build complete!${NC}"
        echo -e "${YELLOW}To create IPA:${NC}"
        echo "1. Open ios/Runner.xcworkspace in Xcode"
        echo "2. Product → Archive"
        echo "3. Window → Organizer"
        echo "4. Distribute App"
        echo ""
        echo "Or use the command line method in BUILD_GUIDE.md"
        
    else
        echo -e "${YELLOW}Building iOS debug...${NC}"
        flutter build ios --debug
        echo -e "${GREEN}iOS debug build complete${NC}"
    fi
}

# Build based on platform
case "$PLATFORM" in
    android)
        build_android
        ;;
    ios)
        build_ios
        ;;
    both)
        build_android
        echo ""
        echo ""
        build_ios
        ;;
    *)
        echo -e "${RED}Error: Invalid platform: $PLATFORM${NC}"
        echo "Usage: $0 [android|ios|both] [debug|release]"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}Build process complete!${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Test the builds on real devices"
echo "2. Check BUILD_GUIDE.md for testing instructions"
echo "3. Refer to RELEASE_NOTES.md for distribution info"
echo ""

cd ..  # Return to root directory
