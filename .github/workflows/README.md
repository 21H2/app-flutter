# GitHub Actions Workflows

This directory contains GitHub Actions workflows for building and releasing the Pawlly Flutter app.

## Available Workflows

### 1. Build and Release (`build-and-release.yml`)

**Purpose**: Automatically build and create a GitHub release with artifacts when a version tag is pushed.

**Triggers**:
- On push of version tags (e.g., `v2.2.6`, `v2.2.7+30`)
- Manual trigger via workflow_dispatch

**What it does**:
- Builds Android APKs (split per ABI for optimal size)
- Builds Android App Bundle (AAB) for Play Store
- Builds iOS app (unsigned, requires signing for distribution)
- Creates GitHub Release with all artifacts
- Generates checksums for verification

**Usage**:
```bash
# Create and push a tag to trigger release
git tag -a v2.2.7 -m "Release version 2.2.7"
git push origin v2.2.7

# Or trigger manually from GitHub Actions UI
```

**Artifacts produced**:
- `app-armeabi-v7a-release.apk` - 32-bit ARM devices
- `app-arm64-v8a-release.apk` - 64-bit ARM devices (most common)
- `app-x86_64-release.apk` - Intel/AMD devices
- `app-release.aab` - App Bundle for Play Store
- `checksums.txt` - SHA256 checksums for verification
- iOS build artifacts (require signing)

### 2. Manual Build (`manual-build.yml`)

**Purpose**: Build the app on-demand with custom options.

**Triggers**: 
- Manual trigger only (workflow_dispatch)

**Options**:
- **Platform**: Choose `android`, `ios`, or `both`
- **Build Mode**: Choose `release` or `debug`

**Usage**:
1. Go to Actions tab in GitHub
2. Select "Manual Build" workflow
3. Click "Run workflow"
4. Choose your options
5. Click "Run workflow" button

**Use cases**:
- Quick test builds
- Debug builds for troubleshooting
- Platform-specific builds

### 3. CI (`ci.yml`)

**Purpose**: Continuous Integration - validates code quality and builds on pull requests.

**Triggers**:
- Pull requests to `main`, `develop`, or `release/**` branches
- Pushes to `main` or `develop` branches
- Only when Flutter app or workflow files change

**What it does**:
- Code analysis with `flutter analyze`
- Format checking with `dart format`
- Test Android debug build
- Test iOS debug build

**Use cases**:
- Ensure PRs don't break builds
- Validate code quality before merge
- Catch issues early in development

## Prerequisites

The workflows handle most setup automatically, but ensure:

1. **Repository settings**:
   - Actions are enabled (Settings → Actions → General)
   - Workflow permissions allow creating releases (Settings → Actions → General → Workflow permissions)

2. **For releases**:
   - Version tags follow format: `v*` (e.g., `v2.2.6`, `v2.2.7+30`)
   - Update version in `pawlly_flutter_app/pubspec.yaml` before tagging

3. **For iOS signing** (optional):
   - Add signing certificates to repository secrets
   - Modify workflow to include signing steps
   - See BUILD_GUIDE.md for details

## Workflow Configuration

### Flutter Version

All workflows use Flutter `3.24.5` as specified in the project requirements. To change:
```yaml
- name: Set up Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.24.5'  # Change here
```

### Java Version

Android builds use Java 17:
```yaml
- name: Set up Java
  uses: actions/setup-java@v4
  with:
    java-version: '17'
```

### Artifact Retention

Build artifacts are kept for:
- **Release builds**: 90 days
- **Manual/CI builds**: 30 days

To change, modify `retention-days` in upload-artifact steps.

## Release Process

### Automatic Release (Recommended)

1. **Update version** in `pawlly_flutter_app/pubspec.yaml`:
   ```yaml
   version: 2.2.7+30
   ```

2. **Update release notes** in `RELEASE_NOTES.md` (optional)

3. **Commit changes**:
   ```bash
   git add pawlly_flutter_app/pubspec.yaml RELEASE_NOTES.md
   git commit -m "Bump version to 2.2.7+30"
   git push
   ```

4. **Create and push tag**:
   ```bash
   git tag -a v2.2.7 -m "Release version 2.2.7 build 30"
   git push origin v2.2.7
   ```

5. **Monitor workflow**:
   - Go to Actions tab in GitHub
   - Watch "Build and Release" workflow
   - Check for any errors

6. **Download artifacts**:
   - Once complete, go to Releases
   - Find your version
   - Download APKs and AAB

### Manual Release

Use the "Manual Build" workflow and then create a release manually:

1. Run "Manual Build" with platform=both, mode=release
2. Download artifacts from workflow run
3. Create release manually in GitHub
4. Upload downloaded artifacts

## Troubleshooting

### Build fails on `flutter analyze`

The analyze step checks code quality. To fix:
```bash
cd pawlly_flutter_app
flutter analyze
# Fix any issues reported
```

### Build fails on "Mock data mode not enabled"

Ensure `lib/configs.dart` has:
```dart
const bool USE_MOCK_DATA = true;
```

### iOS build fails on CocoaPods

This is usually a dependency issue. The workflow runs `pod install` automatically, but if it fails:
- Check `ios/Podfile` for issues
- Verify all Flutter packages are compatible
- Check GitHub Actions logs for specific pod errors

### Workflow doesn't trigger on tag push

Ensure:
- Tag starts with `v` (e.g., `v2.2.7`, not `2.2.7`)
- You pushed the tag: `git push origin v2.2.7`
- Actions are enabled in repository settings

### Release not created

Check:
- Workflow permissions (Settings → Actions → General)
- "Read and write permissions" should be enabled
- "Allow GitHub Actions to create and approve pull requests" may need to be enabled

## Advanced Usage

### Custom Android Signing

To add custom signing, add secrets to repository and modify workflow:

1. **Add secrets** (Settings → Secrets and variables → Actions):
   - `ANDROID_KEYSTORE_BASE64`: Base64 encoded keystore
   - `KEYSTORE_PASSWORD`: Keystore password
   - `KEY_ALIAS`: Key alias
   - `KEY_PASSWORD`: Key password

2. **Modify workflow** to add signing step before build:
   ```yaml
   - name: Setup Android signing
     run: |
       echo "${{ secrets.ANDROID_KEYSTORE_BASE64 }}" | base64 -d > android/app/keystore.jks
       echo "storePassword=${{ secrets.KEYSTORE_PASSWORD }}" >> android/key.properties
       echo "keyPassword=${{ secrets.KEY_PASSWORD }}" >> android/key.properties
       echo "keyAlias=${{ secrets.KEY_ALIAS }}" >> android/key.properties
       echo "storeFile=keystore.jks" >> android/key.properties
   ```

### iOS Code Signing

For automatic iOS IPA creation:

1. Add certificates and provisioning profiles to secrets
2. Add signing steps to workflow
3. Replace `--no-codesign` with proper signing
4. Add IPA export step

See [fastlane documentation](https://docs.fastlane.tools/) for automated iOS signing in CI/CD.

## Monitoring

### Success Indicators

✅ Green checkmarks on all jobs
✅ Artifacts appear in workflow run
✅ Release created (for tag pushes)
✅ APKs and AAB files are downloadable

### Common Issues

❌ Red X on workflow → Check logs in Actions tab
⚠️ Yellow indicator → Some steps passed with warnings
🔵 Blue dot → Workflow is currently running

## Support

For issues with workflows:
1. Check GitHub Actions logs for detailed error messages
2. Review BUILD_GUIDE.md for build requirements
3. Ensure all prerequisites are met
4. Check Flutter and dependency versions

## References

- [Flutter GitHub Actions](https://docs.flutter.dev/deployment/cd#github-actions)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter Build Documentation](https://docs.flutter.dev/deployment)
- Project BUILD_GUIDE.md for detailed build instructions
