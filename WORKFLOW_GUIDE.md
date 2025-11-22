# GitHub Actions Workflow Guide

This document provides a quick reference for using the GitHub Actions workflows in this repository.

## Quick Links
- [Build and Release Workflow](.github/workflows/build-and-release.yml)
- [Manual Build Workflow](.github/workflows/manual-build.yml)
- [CI Workflow](.github/workflows/ci.yml)
- [Detailed Workflow Documentation](.github/workflows/README.md)

## Common Tasks

### 1. Create a Release

**Steps:**
1. Update version in `pawlly_flutter_app/pubspec.yaml`
2. Update `RELEASE_NOTES.md` (optional)
3. Commit changes
4. Create and push tag:
   ```bash
   git tag -a v2.2.7 -m "Release version 2.2.7"
   git push origin v2.2.7
   ```
5. Wait for the "Build and Release" workflow to complete
6. Download artifacts from the GitHub Release page

**Outputs:**
- Android APKs (armeabi-v7a, arm64-v8a, x86_64)
- Android App Bundle (AAB for Play Store)
- iOS build artifacts
- Checksums file

### 2. Manual Build

**Steps:**
1. Go to GitHub repository → Actions tab
2. Select "Manual Build" workflow
3. Click "Run workflow"
4. Choose platform (android/ios/both)
5. Choose build mode (release/debug)
6. Click "Run workflow" button
7. Download artifacts from workflow run

**Use cases:**
- Quick test builds
- Debug builds
- Single platform builds

### 3. Validate Pull Request

**Automatic:**
- CI workflow runs automatically on PRs
- Validates code with `flutter analyze`
- Tests Android and iOS debug builds
- Must pass before merge

**Manual validation:**
```bash
cd pawlly_flutter_app
flutter pub get
flutter analyze
flutter build apk --debug
```

## Workflow Triggers

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| Build and Release | Push tag `v*` | Create official release |
| Build and Release | Manual dispatch | On-demand release build |
| Manual Build | Manual dispatch | Custom build options |
| CI | PR to main/develop | Validate changes |
| CI | Push to main/develop | Validate changes |

## Version Tagging

Follow semantic versioning with build numbers:

**Format:** `v<major>.<minor>.<patch>` or `v<major>.<minor>.<patch>+<build>`

**Examples:**
- `v2.2.6` - Version 2.2.6
- `v2.2.7+30` - Version 2.2.7, build 30
- `v3.0.0` - Major version 3.0.0

**Create tag:**
```bash
# Simple tag
git tag v2.2.7

# Annotated tag (recommended)
git tag -a v2.2.7 -m "Release version 2.2.7"

# Push tag
git push origin v2.2.7
```

## Artifacts

### Android Artifacts

**APKs (Split by ABI):**
- `app-armeabi-v7a-release.apk` - 32-bit ARM (older devices)
- `app-arm64-v8a-release.apk` - 64-bit ARM (most modern phones)
- `app-x86_64-release.apk` - Intel/AMD x86_64 (emulators, tablets)

**App Bundle:**
- `app-release.aab` - For Google Play Store upload

**Checksums:**
- `checksums.txt` - SHA256 hashes for verification

### iOS Artifacts

- `Runner.app` - Unsigned iOS app bundle
- Requires code signing for distribution
- See BUILD_GUIDE.md for IPA creation

### Artifact Retention
- Release builds: 90 days
- Manual/CI builds: 30 days

## Troubleshooting

### Workflow doesn't start
- ✅ Check if Actions are enabled in repository settings
- ✅ Verify tag format starts with `v`
- ✅ Ensure tag was pushed to remote

### Build fails
1. Check workflow logs in Actions tab
2. Common issues:
   - Dependencies not compatible
   - `USE_MOCK_DATA` not set to true
   - Flutter analyze errors
3. Fix locally first:
   ```bash
   cd pawlly_flutter_app
   flutter clean
   flutter pub get
   flutter analyze
   flutter build apk --release
   ```

### Release not created
- ✅ Check workflow permissions: Settings → Actions → General
- ✅ Enable "Read and write permissions"
- ✅ Workflow must be triggered by tag push (not manual)

### iOS build fails
- Usually CocoaPods related
- Check `ios/Podfile` compatibility
- Review workflow logs for pod errors

## Best Practices

### Before Creating Release
1. ✅ Test app locally on real devices
2. ✅ Update version in `pubspec.yaml`
3. ✅ Update `RELEASE_NOTES.md`
4. ✅ Run `flutter analyze` - fix all issues
5. ✅ Verify `USE_MOCK_DATA = true` in `lib/configs.dart`
6. ✅ Test manual build first (optional)
7. ✅ Create and push tag

### After Release Created
1. ✅ Download and verify APKs
2. ✅ Test installation on real devices
3. ✅ Verify checksums
4. ✅ Test all major features
5. ✅ Update any release documentation
6. ✅ Announce release

### Version Management
- Increment **patch** (2.2.6 → 2.2.7) for bug fixes
- Increment **minor** (2.2.7 → 2.3.0) for new features
- Increment **major** (2.3.0 → 3.0.0) for breaking changes
- Increment **build number** (+28 → +29) for each build

## Security Notes

### Secrets Management
If adding signing or API keys:
1. Never commit secrets to repository
2. Use GitHub Secrets (Settings → Secrets)
3. Reference in workflow: `${{ secrets.SECRET_NAME }}`

### Code Signing
- Android: Optional (can be added)
- iOS: Required for distribution
- See advanced documentation in `.github/workflows/README.md`

## Resources

### Documentation
- [Detailed Workflow Documentation](.github/workflows/README.md)
- [Build Guide](BUILD_GUIDE.md)
- [Build Workflow](BUILD_WORKFLOW.md)

### External Resources
- [Flutter CI/CD Documentation](https://docs.flutter.dev/deployment/cd)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter Build Documentation](https://docs.flutter.dev/deployment)

## Support

For issues:
1. Check workflow logs in Actions tab
2. Review BUILD_GUIDE.md
3. Consult `.github/workflows/README.md`
4. Ensure all prerequisites are met

## Summary

The GitHub Actions workflows automate the entire build and release process:

✅ **Automated**: Push a tag, get a release
✅ **Flexible**: Manual builds with custom options
✅ **Validated**: CI ensures code quality
✅ **Comprehensive**: Android and iOS support
✅ **Documented**: Clear instructions and troubleshooting

Start with a manual build to test, then use tag-based releases for production!
