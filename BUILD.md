# Build Instructions

## Quick Start

### 1. Run the App in Debug Mode

```bash
flutter run
```

This will launch the app on your connected device or emulator.

### 2. Build Release APK

To create a release APK for submission:

```bash
flutter build apk --release
```

The APK will be generated at:

```
build/app/outputs/flutter-apk/app-release.apk
```

### 3. Build Split APKs (Recommended for smaller file sizes)

```bash
flutter build apk --split-per-abi
```

This creates separate APKs for different architectures:

- `app-armeabi-v7a-release.apk` (ARM 32-bit)
- `app-arm64-v8a-release.apk` (ARM 64-bit)
- `app-x86_64-release.apk` (x86 64-bit)

Located in: `build/app/outputs/flutter-apk/`

### 4. Build App Bundle (For Google Play Store)

```bash
flutter build appbundle
```

The bundle will be at:

```
build/app/outputs/bundle/release/app-release.aab
```

## Pre-Build Checklist

Before building, ensure:

1. **Dependencies are installed:**

   ```bash
   flutter pub get
   ```

2. **No errors in the code:**

   ```bash
   flutter analyze
   ```

3. **App runs successfully:**
   ```bash
   flutter run --release
   ```

## Testing the APK

### Install on Device

1. Transfer the APK to your Android device
2. Enable "Install from Unknown Sources" in device settings
3. Tap the APK file to install
4. Open the app and test all features

### Test Checklist

- [ ] Login with any email (valid format) and password (6+ chars)
- [ ] View tickets list with filters (All/Active/Resolved)
- [ ] Pull to refresh tickets
- [ ] Tap a ticket to view details
- [ ] Mark a ticket as resolved
- [ ] Navigate between Tickets and Profile tabs
- [ ] View profile with email
- [ ] Switch themes (Light/Dark/System)
- [ ] Logout and verify data is cleared
- [ ] Login again and verify resolved tickets persist

## Build Configuration

### App Details

- **App Name:** Ticket Resolution
- **Package Name:** com.example.ticket_app
- **Version:** 1.0.0+1
- **Min SDK:** 21 (Android 5.0)
- **Target SDK:** Latest

### Signing (Optional for Release)

To sign the APK, create a keystore:

1. Generate keystore:

   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. Create `android/key.properties`:

   ```properties
   storePassword=<password>
   keyPassword=<password>
   keyAlias=upload
   storeFile=<path-to-keystore>
   ```

3. Update `android/app/build.gradle` to use the keystore

## Troubleshooting

### Issue: Gradle build fails

**Solution:** Clean the project and rebuild

```bash
flutter clean
flutter pub get
flutter build apk --release
```

### Issue: APK size is too large

**Solution:** Use split APKs or enable code shrinking

```bash
flutter build apk --split-per-abi --shrink
```

### Issue: App crashes on startup

**Solution:** Check logs

```bash
flutter logs
```

## Size Optimization

The release APK is optimized with:

- Code shrinking
- Resource shrinking
- ProGuard/R8 obfuscation
- Compressed assets

Expected APK size: ~20-40 MB (depending on architecture)

## GitHub Repository Setup

1. Initialize git:

   ```bash
   git init
   ```

2. Add all files:

   ```bash
   git add .
   ```

3. Commit:

   ```bash
   git commit -m "Initial commit: Ticket Resolution App"
   ```

4. Create GitHub repository and push:

   ```bash
   git remote add origin <your-repo-url>
   git branch -M main
   git push -u origin main
   ```

5. Add the APK to the repository:
   ```bash
   git add build/app/outputs/flutter-apk/app-release.apk
   git commit -m "Add release APK"
   git push
   ```

## Submission

After building, include in your submission:

1. ✅ GitHub repository URL
2. ✅ Release APK (in the repo or shared separately)
3. ✅ README.md with documentation
4. ✅ FEATURES.md with highlights

## Support

For issues or questions:

- Check the README.md for setup instructions
- Review FEATURES.md for implementation details
- Ensure all dependencies are installed with `flutter pub get`
- Run `flutter doctor` to verify your development environment

---

**Ready to build!** Run `flutter build apk --release` to create your submission APK.
