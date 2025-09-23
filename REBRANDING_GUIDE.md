# Complete App Rebranding Guide

This guide provides step-by-step instructions for changing the logo, app name, and package name across Linux, macOS, Windows, Android, and iOS platforms.

## Prerequisites

### Required Tools
- **Image Processing**: `rsvg-convert` (for SVG conversion), `iconutil` (macOS), `ImageMagick`
- **Development Tools**: Flutter SDK, Xcode (macOS/iOS), Android SDK
- **Text Editor**: Any code editor (VS Code, Sublime Text, etc.)

### Install Required Tools

#### Linux/macOS
```bash
# Install rsvg-convert (for SVG to PNG conversion)
# Ubuntu/Debian
sudo apt install librsvg2-bin imagemagick

# macOS
brew install librsvg imagemagick

# CentOS/RHEL/Fedora
sudo dnf install librsvg2-tools ImageMagick
```

#### Windows
```cmd
# Install ImageMagick from https://imagemagick.org/script/download.php#windows
# Install Inkscape (includes command line tools) from https://inkscape.org/release/
```

## Step 1: Prepare Your New Logo

### Logo Requirements
Your logo should be:
- **Format**: SVG (vector format for best quality)
- **Design**: Square aspect ratio (1:1)
- **Colors**: Consider how it looks on both light and dark backgrounds
- **Simplicity**: Clear and recognizable at small sizes

### Example SVG Structure
```xml
<?xml version="1.0" encoding="utf-8"?>
<svg width="512" height="512" viewBox="0 0 512 512" xmlns="http://www.w3.org/2000/svg">
  <!-- Your logo content here -->
  <path d="..." fill="#yourcolor"/>
</svg>
```

## Step 2: Generate Platform-Specific Icons

### Create Icon Generation Script

Create a file `generate_icons.sh` (Linux/macOS) or `generate_icons.bat` (Windows):

#### Linux/macOS Script
```bash
#!/bin/bash
# generate_icons.sh

SVG_FILE="assets/your_logo.svg"

if [ ! -f "$SVG_FILE" ]; then
    echo "Error: SVG file not found at $SVG_FILE"
    exit 1
fi

echo "Generating icons from $SVG_FILE..."

# Create temporary directory
mkdir -p temp_icons

# Generate various sizes
rsvg-convert -w 16 -h 16 "$SVG_FILE" -o temp_icons/icon_16.png
rsvg-convert -w 20 -h 20 "$SVG_FILE" -o temp_icons/icon_20.png
rsvg-convert -w 29 -h 29 "$SVG_FILE" -o temp_icons/icon_29.png
rsvg-convert -w 32 -h 32 "$SVG_FILE" -o temp_icons/icon_32.png
rsvg-convert -w 40 -h 40 "$SVG_FILE" -o temp_icons/icon_40.png
rsvg-convert -w 48 -h 48 "$SVG_FILE" -o temp_icons/icon_48.png
rsvg-convert -w 58 -h 58 "$SVG_FILE" -o temp_icons/icon_58.png
rsvg-convert -w 60 -h 60 "$SVG_FILE" -o temp_icons/icon_60.png
rsvg-convert -w 64 -h 64 "$SVG_FILE" -o temp_icons/icon_64.png
rsvg-convert -w 72 -h 72 "$SVG_FILE" -o temp_icons/icon_72.png
rsvg-convert -w 76 -h 76 "$SVG_FILE" -o temp_icons/icon_76.png
rsvg-convert -w 80 -h 80 "$SVG_FILE" -o temp_icons/icon_80.png
rsvg-convert -w 87 -h 87 "$SVG_FILE" -o temp_icons/icon_87.png
rsvg-convert -w 96 -h 96 "$SVG_FILE" -o temp_icons/icon_96.png
rsvg-convert -w 120 -h 120 "$SVG_FILE" -o temp_icons/icon_120.png
rsvg-convert -w 128 -h 128 "$SVG_FILE" -o temp_icons/icon_128.png
rsvg-convert -w 144 -h 144 "$SVG_FILE" -o temp_icons/icon_144.png
rsvg-convert -w 152 -h 152 "$SVG_FILE" -o temp_icons/icon_152.png
rsvg-convert -w 167 -h 167 "$SVG_FILE" -o temp_icons/icon_167.png
rsvg-convert -w 180 -h 180 "$SVG_FILE" -o temp_icons/icon_180.png
rsvg-convert -w 192 -h 192 "$SVG_FILE" -o temp_icons/icon_192.png
rsvg-convert -w 256 -h 256 "$SVG_FILE" -o temp_icons/icon_256.png
rsvg-convert -w 512 -h 512 "$SVG_FILE" -o temp_icons/icon_512.png
rsvg-convert -w 1024 -h 1024 "$SVG_FILE" -o temp_icons/icon_1024.png

echo "Icons generated successfully in temp_icons/"
```

#### Windows Script
```batch
@echo off
REM generate_icons.bat

set SVG_FILE=assets\your_logo.svg

if not exist "%SVG_FILE%" (
    echo Error: SVG file not found at %SVG_FILE%
    exit /b 1
)

echo Generating icons from %SVG_FILE%...

REM Create temporary directory
if not exist temp_icons mkdir temp_icons

REM Use Inkscape command line (adjust path as needed)
set INKSCAPE="C:\Program Files\Inkscape\bin\inkscape.exe"

%INKSCAPE% --export-type=png --export-width=16 --export-height=16 --export-filename=temp_icons\icon_16.png %SVG_FILE%
%INKSCAPE% --export-type=png --export-width=20 --export-height=20 --export-filename=temp_icons\icon_20.png %SVG_FILE%
REM ... (continue for all required sizes)

echo Icons generated successfully in temp_icons\
```

### Make Script Executable and Run
```bash
# Linux/macOS
chmod +x generate_icons.sh
./generate_icons.sh

# Windows
generate_icons.bat
```

## Step 3: Update Flutter Configuration

### 3.1 Update pubspec.yaml
**File**: `flutter/pubspec.yaml`

```yaml
name: your_new_app_name  # Change this
description: Your New App Description  # Change this

# Update flutter_icons configuration
flutter_icons:
  image_path: "../res/your_new_icon.png"  # Update path
  remove_alpha_ios: true
  android: true
  ios: true
  windows:
    generate: true
  macos:
    image_path: "../res/your_new_mac_icon.png"  # Update path
    generate: true
  linux: true
  web:
    generate: true
```

### 3.2 Replace Icon Files
Copy your new icon to the Flutter assets:
```bash
# Copy your new SVG logo
cp your_new_logo.svg flutter/assets/

# Update the main icon files
cp temp_icons/icon_1024.png res/icon.png
cp temp_icons/icon_1024.png res/mac-icon.png
```

## Step 4: Platform-Specific Updates

### 4.1 Android Configuration

#### Update Package Name
**File**: `flutter/android/app/src/main/AndroidManifest.xml`
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.yourcompany.your_new_app_name">  <!-- Change this line -->
```

#### Update App Label
**File**: `flutter/android/app/src/main/AndroidManifest.xml`
```xml
<application
    android:icon="@mipmap/ic_launcher"
    android:label="Your New App Name"  <!-- Change this line -->
    android:roundIcon="@mipmap/ic_launcher"
    android:supportsRtl="true">
```

#### Update Service Labels
**File**: `flutter/android/app/src/main/AndroidManifest.xml`
```xml
<service
    android:name=".InputService"
    android:enabled="true"
    android:exported="false"
    android:label="Your New App Name Input"  <!-- Change this line -->
    android:permission="android.permission.BIND_ACCESSIBILITY_SERVICE">
```

#### Update Build Configuration
**File**: `flutter/android/app/build.gradle`
```gradle
android {
    defaultConfig {
        applicationId "com.yourcompany.your_new_app_name"  // Change this line
        // ... other configurations
    }
}
```

#### Update Android Icons
```bash
# Copy generated icons to Android directories
cp temp_icons/icon_48.png flutter/android/app/src/main/res/mipmap-mdpi/ic_launcher.png
cp temp_icons/icon_72.png flutter/android/app/src/main/res/mipmap-hdpi/ic_launcher.png
cp temp_icons/icon_96.png flutter/android/app/src/main/res/mipmap-xhdpi/ic_launcher.png
cp temp_icons/icon_144.png flutter/android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png
cp temp_icons/icon_192.png flutter/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png
```

### 4.2 iOS Configuration

#### Update Bundle Identifier
**File**: `flutter/ios/Runner.xcodeproj/project.pbxproj`
Search for `PRODUCT_BUNDLE_IDENTIFIER` and update:
```
PRODUCT_BUNDLE_IDENTIFIER = com.yourcompany.yourNewAppName;
```

#### Update App Display Name
**File**: `flutter/ios/Runner/Info.plist`
```xml
<key>CFBundleDisplayName</key>
<string>Your New App Name</string>  <!-- Change this line -->

<key>CFBundleName</key>
<string>Your New App Name</string>  <!-- Change this line -->
```

#### Update URL Scheme (if applicable)
**File**: `flutter/ios/Runner/Info.plist`
```xml
<key>CFBundleURLName</key>
<string>com.yourcompany.yournewappname</string>  <!-- Change this line -->
<key>CFBundleURLSchemes</key>
<array>
    <string>yournewappname</string>  <!-- Change this line -->
</array>
```

#### Update iOS Icons
Create iconset structure:
```bash
# Create iconset directory
mkdir -p ios_iconset.iconset

# Copy icons with proper naming
cp temp_icons/icon_16.png ios_iconset.iconset/icon_16x16.png
cp temp_icons/icon_32.png ios_iconset.iconset/icon_16x16@2x.png
cp temp_icons/icon_32.png ios_iconset.iconset/icon_32x32.png
cp temp_icons/icon_64.png ios_iconset.iconset/icon_32x32@2x.png
cp temp_icons/icon_128.png ios_iconset.iconset/icon_128x128.png
cp temp_icons/icon_256.png ios_iconset.iconset/icon_128x128@2x.png
cp temp_icons/icon_256.png ios_iconset.iconset/icon_256x256.png
cp temp_icons/icon_512.png ios_iconset.iconset/icon_256x256@2x.png
cp temp_icons/icon_512.png ios_iconset.iconset/icon_512x512.png
cp temp_icons/icon_1024.png ios_iconset.iconset/icon_512x512@2x.png

# Copy individual iOS icons
cp temp_icons/icon_20.png flutter/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png
cp temp_icons/icon_40.png flutter/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png
cp temp_icons/icon_60.png flutter/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png
cp temp_icons/icon_29.png flutter/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png
cp temp_icons/icon_58.png flutter/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png
cp temp_icons/icon_87.png flutter/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png
cp temp_icons/icon_40.png flutter/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png
cp temp_icons/icon_80.png flutter/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png
cp temp_icons/icon_120.png flutter/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png
cp temp_icons/icon_120.png flutter/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png
cp temp_icons/icon_180.png flutter/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png
cp temp_icons/icon_76.png flutter/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png
cp temp_icons/icon_152.png flutter/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png
cp temp_icons/icon_167.png flutter/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png
cp temp_icons/icon_1024.png flutter/ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png
```

### 4.3 macOS Configuration

#### Update App Name
**File**: `flutter/macos/Runner/Info.plist`
```xml
<key>CFBundleDisplayName</key>
<string>Your New App Name</string>  <!-- Change this line -->

<key>CFBundleName</key>
<string>Your New App Name</string>  <!-- Change this line -->
```

#### Update Bundle Identifier
**File**: `flutter/macos/Runner/Configs/AppInfo.xcconfig`
```
PRODUCT_BUNDLE_IDENTIFIER = com.yourcompany.yourNewAppName  // Change this line
```

#### Create macOS Icons
```bash
# Create ICNS file from iconset
iconutil --convert icns --output flutter/macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_1024.png ios_iconset.iconset

# Or create individual icons
cp temp_icons/icon_1024.png flutter/macos/Runner/Assets.xcassets/AppIcon.appiconset/
```

### 4.4 Linux Configuration

#### Update Binary Name
**File**: `flutter/linux/CMakeLists.txt`
```cmake
set(BINARY_NAME "your_new_app_name")  # Change this line
```

#### Update Application ID
**File**: `flutter/linux/CMakeLists.txt`
```cmake
set(APPLICATION_ID "com.yourcompany.your_new_app_name")  # Change this line
```

#### Update Desktop Entry (Optional)
Create or update: `flutter/linux/your_new_app_name.desktop`
```ini
[Desktop Entry]
Name=Your New App Name
Comment=Your app description
Exec=your_new_app_name
Icon=your_new_app_name
Terminal=false
Type=Application
Categories=Network;RemoteAccess;
```

### 4.5 Windows Configuration

#### Update App Name
**File**: `flutter/windows/runner/main.cpp`
Look for the line with app_name and update:
```cpp
std::wstring app_name = L"Your New App Name";  // Change this line
```

#### Update Window Class Name
**File**: `flutter/windows/runner/win32_window.cpp`
```cpp
const wchar_t kWindowClassName[] = L"YourNewAppNameWindow";  // Change this line
```

#### Create Windows Icons
```bash
# Create ICO file with multiple sizes
magick temp_icons/icon_256.png temp_icons/icon_128.png temp_icons/icon_96.png temp_icons/icon_72.png temp_icons/icon_48.png temp_icons/icon_32.png temp_icons/icon_16.png flutter/windows/runner/resources/app_icon.ico
```

## Step 5: Update Source Code References

### 5.1 Search and Replace App Name in Code
Use your text editor or command line to find and replace references:

```bash
# Linux/macOS - Find all references to old app name
grep -r "OldAppName" flutter/lib/
grep -r "old_app_name" flutter/lib/

# Replace in specific files
sed -i 's/OldAppName/YourNewAppName/g' flutter/lib/**/*.dart
sed -i 's/old_app_name/your_new_app_name/g' flutter/lib/**/*.dart
```

### 5.2 Common Files to Check
- `flutter/lib/main.dart` - App initialization
- `flutter/lib/models/model.dart` - App configuration
- `flutter/lib/common/widgets/dialog.dart` - Dialog titles
- Any configuration files with hardcoded app names

## Step 6: Update Rust Backend (if applicable)

### 6.1 Update Cargo.toml
**File**: `Cargo.toml`
```toml
[package]
name = "your_new_app_name"  # Change this line
description = "Your new app description"  # Change this line
```

### 6.2 Update Application Constants
Look for files containing app name constants:
- `src/main.rs`
- `src/common.rs`
- `libs/hbb_common/src/config.rs`

```rust
// Example updates
pub const APP_NAME: &str = "Your New App Name";  // Change this line
pub const SERVICE_NAME: &str = "your_new_app_name";  // Change this line
```

## Step 7: Clean and Rebuild

### 7.1 Clean Previous Builds
```bash
# Clean Flutter
cd flutter
flutter clean
flutter pub get

# Clean Rust
cargo clean

# Clean platform-specific builds
rm -rf flutter/build/
```

### 7.2 Regenerate Icons (if using flutter_launcher_icons)
```bash
cd flutter
flutter pub run flutter_launcher_icons:main
```

### 7.3 Test Builds
```bash
# Test Android build
flutter build apk --debug

# Test iOS build (macOS only)
flutter build ios --debug

# Test desktop builds
flutter build linux --debug    # Linux
flutter build macos --debug    # macOS
flutter build windows --debug  # Windows
```

## Step 8: Verification Checklist

### ✅ Visual Verification
- [ ] New logo appears in app launcher/desktop
- [ ] New logo appears in app title bar
- [ ] New logo appears in system tray (if applicable)
- [ ] App name appears correctly in all system dialogs

### ✅ Functional Verification
- [ ] App launches successfully on all platforms
- [ ] No broken references to old name/logo
- [ ] Package installation works with new name
- [ ] Deep links work with new URL scheme (if applicable)

### ✅ File Verification
- [ ] All icon files are updated and correct size
- [ ] All configuration files reference new names
- [ ] Build artifacts use new names
- [ ] No leftover old branding files

## Step 9: Documentation Updates

### 9.1 Update README Files
- Update app description and name
- Update installation instructions
- Update screenshot with new branding

### 9.2 Update Build Scripts
- Update any build scripts that reference old names
- Update CI/CD pipelines with new artifact names
- Update distribution scripts

## Troubleshooting

### Common Issues

#### Icons Not Updating
```bash
# Clear Flutter caches
flutter clean
flutter pub cache repair

# Regenerate icons
flutter pub run flutter_launcher_icons:main
```

#### Package Name Conflicts
```bash
# Make sure to update all references consistently
grep -r "old.package.name" .
```

#### Build Errors After Renaming
```bash
# Clean all build artifacts
flutter clean
cargo clean
rm -rf build/
rm -rf target/

# Rebuild from scratch
flutter pub get
flutter build [platform] --debug
```

#### Platform-Specific Issues

**Android**: Clear app data and reinstall APK
```bash
adb uninstall com.old.package.name
adb install app-debug.apk
```

**iOS**: Clean Xcode build folder and rebuild
```bash
cd flutter/ios
xcodebuild clean
cd ../..
flutter build ios
```

**macOS**: Reset codesigning if needed
```bash
codesign --remove-signature YourApp.app
codesign --sign - --force --deep YourApp.app
```

## Final Notes

1. **Backup First**: Always backup your project before making extensive changes
2. **Test Thoroughly**: Test on all target platforms after rebranding
3. **Version Control**: Commit changes incrementally to track what works
4. **Documentation**: Update all documentation to reflect new branding
5. **Distribution**: Update app store listings, websites, and download links

This guide covers the complete rebranding process. Adjust the specific file paths and names according to your project structure and new branding requirements.