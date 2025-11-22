# Quick Start: GitHub Actions Workflows

Get started with automated builds in 2 minutes!

## Prerequisites

✅ Repository with GitHub Actions enabled  
✅ Version updated in `pawlly_flutter_app/pubspec.yaml`  
✅ `USE_MOCK_DATA = true` in `pawlly_flutter_app/lib/configs.dart`

## Option 1: Automatic Release (Recommended)

Create a release with one command:

```bash
# 1. Update version in pubspec.yaml first, then:
git tag -a v2.2.7 -m "Release version 2.2.7"
git push origin v2.2.7

# 2. Wait ~10-15 minutes for builds to complete

# 3. Go to GitHub → Releases → Download your APKs and AAB
```

**That's it!** The workflow will:
- ✅ Build Android APKs (3 variants)
- ✅ Build Android App Bundle (AAB)
- ✅ Build iOS app
- ✅ Create GitHub Release
- ✅ Upload all artifacts

## Option 2: Manual Build

For testing or custom builds:

1. Go to your repository on GitHub
2. Click **Actions** tab
3. Click **Manual Build** workflow
4. Click **Run workflow** button
5. Choose:
   - Platform: `android`, `ios`, or `both`
   - Build mode: `release` or `debug`
6. Click **Run workflow**
7. Wait for completion (~5-10 minutes)
8. Download artifacts from the workflow run

## Option 3: Test on Pull Request

CI runs automatically on PRs:

1. Create a pull request
2. CI workflow runs automatically
3. Check for green checkmarks
4. Fix any issues if red X appears
5. Merge when all checks pass

## Downloading Build Artifacts

### From GitHub Release (Option 1)
1. Go to repository → **Releases**
2. Find your version (e.g., v2.2.7)
3. Download under **Assets**:
   - `app-arm64-v8a-release.apk` (most common)
   - `app-release.aab` (for Play Store)
   - `checksums.txt` (for verification)

### From Workflow Run (Option 2)
1. Go to repository → **Actions**
2. Click the workflow run
3. Scroll down to **Artifacts**
4. Click to download (zip file)
5. Extract the zip file

## Verifying Downloads

Verify APK checksums:

```bash
# On Linux/Mac
sha256sum app-*.apk
cat checksums.txt

# On Windows (PowerShell)
Get-FileHash app-*.apk -Algorithm SHA256
```

## Installation

### Android
```bash
# Via ADB
adb install app-arm64-v8a-release.apk

# Or manually on device:
# 1. Transfer APK to device
# 2. Enable "Install from Unknown Sources"
# 3. Tap APK to install
```

### iOS
iOS requires code signing - see [BUILD_GUIDE.md](BUILD_GUIDE.md) for IPA creation.

## Troubleshooting

### Workflow doesn't start
- ✅ Check: Tag starts with `v` (e.g., `v2.2.7`)
- ✅ Check: Tag was pushed: `git push origin v2.2.7`
- ✅ Check: Actions enabled in Settings → Actions

### Build fails
- ✅ Check workflow logs in Actions tab
- ✅ Look for error messages in red
- ✅ Common fix: Run `flutter analyze` locally and fix issues

### No release created
- ✅ Check: Workflow permissions (Settings → Actions → General)
- ✅ Enable: "Read and write permissions"

## Next Steps

📖 **Detailed Documentation**: [WORKFLOW_GUIDE.md](WORKFLOW_GUIDE.md)  
🔧 **Advanced Configuration**: [.github/workflows/README.md](.github/workflows/README.md)  
🏗️ **Manual Build Guide**: [BUILD_GUIDE.md](BUILD_GUIDE.md)

## Support

Need help?
1. Check [WORKFLOW_GUIDE.md](WORKFLOW_GUIDE.md) for common tasks
2. Review workflow logs for error messages
3. Consult [FAQ.md](FAQ.md) for general questions

---

**TIP**: Test with a manual build first before creating an official release!
