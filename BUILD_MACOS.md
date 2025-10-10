# Building NaiveRustDesk on macOS

This guide explains how to build NaiveRustDesk executables on macOS for desktop and mobile platforms.

## Prerequisites

### System Requirements
- macOS 10.14 (Mojave) or later
- Xcode 12.0 or later
- Command Line Tools for Xcode

### Install Xcode and Command Line Tools
```bash
# Install Xcode from App Store, then install command line tools
xcode-select --install

# Accept Xcode license
sudo xcodebuild -license accept
```

### Install Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Install System Dependencies
```bash
# Required build tools and libraries
brew install git curl wget cmake pkg-config

# Audio and system libraries
brew install portaudio

# Optional: For better build performance
brew install ccache ninja
```

### Rust Installation
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
rustup default stable

# Add iOS targets for mobile development
rustup target add aarch64-apple-ios x86_64-apple-ios aarch64-apple-ios-sim
```

### Flutter Installation
```bash
# Download Flutter
cd ~/Development
git clone https://github.com/flutter/flutter.git -b stable --depth 1

# Add to PATH
echo 'export PATH="$PATH:$HOME/Development/flutter/bin"' >> ~/.zshrc
source ~/.zshrc

# Run Flutter doctor
flutter doctor

# Accept licenses
flutter doctor --android-licenses  # For Android development
```

### vcpkg Setup (for C++ dependencies)
```bash
cd ~/Development
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
./bootstrap-vcpkg.sh
export VCPKG_ROOT=$HOME/Development/vcpkg
echo 'export VCPKG_ROOT=$HOME/Development/vcpkg' >> ~/.zshrc

# Install required packages
./vcpkg install libvpx libyuv opus aom
```

### Sciter Library (for legacy UI support)
```bash
# Download appropriate Sciter library
cd ~/Downloads
# Visit https://sciter.com/download/ and download macOS library
# Extract and place in your project directory
```

## Building

### 1. Clone the Repository
```bash
git clone https://github.com/your-repo/naiveRustdesk.git
cd naiveRustdesk
```

### 2. Build Desktop Application (Flutter)

#### Debug Build
```bash
# Build debug version
python3 build.py --flutter

# Alternative: Direct Flutter build
cd flutter
flutter build macos --debug
```

#### Release Build
```bash
# Build release version
python3 build.py --flutter --release

# Alternative: Direct Flutter build
cd flutter
flutter build macos --release

# Build with hardware codec support
python3 build.py --flutter --release --hwcodec
```

### 3. Build Rust Backend Only
```bash
# Debug build
cargo build

# Release build
cargo build --release

# With hardware codec
cargo build --release --features hwcodec

# For Apple Silicon Macs, you can build universal binaries
cargo build --release --target universal2-apple-darwin
```

### 4. Build for iOS

#### Setup iOS Development
```bash
# Make sure you have iOS development setup
flutter doctor

# Install CocoaPods (if not already installed)
sudo gem install cocoapods
```

#### Build iOS App
```bash
cd flutter

# Clean previous builds
flutter clean
flutter pub get

# Build for iOS Simulator
flutter build ios --simulator --release

# Build for iOS Device (requires Apple Developer account)
flutter build ios --release

# Build iOS IPA (for distribution)
flutter build ipa --release

# Open in Xcode for advanced configuration
open ios/Runner.xcworkspace
```

### 5. Code Signing and Notarization

#### For Development (self-signed)
After building, the app needs to be code-signed to run on macOS. For local development and testing, use an ad-hoc signature:

```bash
# Sign with ad-hoc signature (for local testing)
codesign --sign - --force --deep flutter/build/macos/Build/Products/Release/R-connect.app

# Verify the signature
codesign --verify --verbose flutter/build/macos/Build/Products/Release/R-connect.app

# Check signature details
codesign -dvv flutter/build/macos/Build/Products/Release/R-connect.app
```

**Note**: If you get "a sealed resource is missing or invalid" error, it means files were modified after signing. Re-run the codesign command above.

#### For Distribution (requires Apple Developer account)
```bash
# Check available signing identities
security find-identity -v -p codesigning

# Sign the application with Developer ID
codesign --sign "Developer ID Application: Your Name" --force --deep --verbose flutter/build/macos/Build/Products/Release/R-connect.app

# Verify the signature
codesign --verify --deep --strict --verbose=2 flutter/build/macos/Build/Products/Release/R-connect.app

# Create DMG for distribution
hdiutil create -srcfolder flutter/build/macos/Build/Products/Release/R-connect.app R-connect.dmg

# Notarize with Apple (for distribution outside App Store)
xcrun notarytool submit R-connect.dmg --apple-id "your-apple-id@example.com" --password "@keychain:Developer-altool" --team-id "YOUR_TEAM_ID" --wait

# Staple the notarization ticket
xcrun stapler staple R-connect.dmg

# Verify notarization
spctl --assess --type execute --verbose R-connect.app
```

### 6. Build Universal Binary (Intel + Apple Silicon)
```bash
# Build for both architectures
python3 build.py --flutter --release --universal

# Or manually build for specific targets
cd flutter
flutter build macos --release --target-platform darwin-x64
flutter build macos --release --target-platform darwin-arm64

# Combine into universal binary using lipo
lipo -create -output NaiveRustDesk-universal build/macos/Build/Products/Release-x64/NaiveRustDesk.app/Contents/MacOS/NaiveRustDesk build/macos/Build/Products/Release-arm64/NaiveRustDesk.app/Contents/MacOS/NaiveRustDesk
```

## Build Outputs

### Desktop macOS
- **App Bundle**: `flutter/build/macos/Build/Products/Release/R-connect.app`
- **Executable**: `flutter/build/macos/Build/Products/Release/R-connect.app/Contents/MacOS/R-connect`

### iOS
- **iOS App**: `flutter/build/ios/iphoneos/Runner.app`
- **IPA File**: `flutter/build/ios/ipa/naive_rust_desk.ipa`

## Running the Application

### Desktop macOS
```bash
# Run from build directory
open flutter/build/macos/Build/Products/Release/R-connect.app

# Or run executable directly
flutter/build/macos/Build/Products/Release/R-connect.app/Contents/MacOS/R-connect

# Install to Applications folder
cp -r flutter/build/macos/Build/Products/Release/R-connect.app /Applications/
```

### iOS
```bash
# Run on simulator
flutter run -d "iPhone 14 Pro Simulator"

# Install on connected device
flutter install -d "Your iPhone"

# Or install IPA using Xcode or third-party tools
```

## Troubleshooting

### Common Issues

#### Missing Dependencies
```bash
# If you get library errors, update Homebrew packages:
brew update
brew upgrade

# Install missing packages:
brew install portaudio cmake pkg-config
```

#### Code Signing Issues
```bash
# Check available certificates
security find-identity -v -p codesigning

# Remove old signatures
codesign --remove-signature flutter/build/macos/Build/Products/Release/R-connect.app

# Re-sign with ad-hoc signature (for development)
codesign --sign - --force --deep flutter/build/macos/Build/Products/Release/R-connect.app

# Or re-sign with Developer ID (for distribution)
codesign --sign "Developer ID Application: Your Name" --force --deep flutter/build/macos/Build/Products/Release/R-connect.app
```

#### iOS Build Issues
```bash
# Clean iOS build
cd flutter
flutter clean
rm -rf ios/Pods ios/Podfile.lock
flutter pub get
cd ios && pod install --repo-update && cd ..
flutter build ios --release
```

#### macOS Permission Issues
```bash
# If the app can't access certain features, add entitlements:
# Edit flutter/macos/Runner/Release.entitlements
```

#### Flutter Issues
```bash
# Clean and rebuild
cd flutter
flutter clean
flutter pub get
flutter build macos --release --verbose

# Update Flutter
flutter upgrade
```

### Performance Optimization

#### For better performance:
```bash
# Enable hardware acceleration
python3 build.py --flutter --release --hwcodec

# Use optimized Rust flags
RUSTFLAGS="-C target-cpu=native" cargo build --release

# For Apple Silicon optimization
RUSTFLAGS="-C target-cpu=apple-a14" cargo build --release --target aarch64-apple-darwin
```

#### For debugging:
```bash
# Build with debug symbols
python3 build.py --flutter --debug

# Run with debugging
RUST_LOG=debug flutter/build/macos/Build/Products/Debug/R-connect.app/Contents/MacOS/R-connect
```

## Distribution

### Creating DMG Installer
```bash
# Create a nice DMG with background and layout
mkdir -p dmg-temp
cp -r flutter/build/macos/Build/Products/Release/NaiveRustDesk.app dmg-temp/
ln -s /Applications dmg-temp/Applications

# Create DMG
hdiutil create -srcfolder dmg-temp -volname "NaiveRustDesk" -fs HFS+ -fsargs "-c c=64,a=16,e=16" -format UDRW temp.dmg
hdiutil attach temp.dmg -readwrite

# Add background image and set layout (optional)
# ... (custom DMG styling steps)

hdiutil detach /Volumes/NaiveRustDesk
hdiutil convert temp.dmg -format UDZO -o NaiveRustDesk-macOS.dmg
rm -rf dmg-temp temp.dmg
```

### App Store Distribution
```bash
# Build for App Store
cd flutter
flutter build macos --release --obfuscate --split-debug-info=debug-info/

# Create App Store package
xcrun productbuild --component flutter/build/macos/Build/Products/Release/NaiveRustDesk.app /Applications NaiveRustDesk-AppStore.pkg

# Upload to App Store Connect
xcrun altool --upload-package NaiveRustDesk-AppStore.pkg --type macos --username "your-apple-id@example.com" --password "@keychain:Developer-altool"
```

### Homebrew Cask (for easy installation)
```ruby
# Create Homebrew cask formula
# File: homebrew-naiveRustdesk/Casks/naiveRustdesk.rb
cask "naiveRustdesk" do
  version "1.4.2"
  sha256 "your-sha256-hash"

  url "https://github.com/your-repo/naiveRustdesk/releases/download/v#{version}/NaiveRustDesk-macOS.dmg"
  name "NaiveRustDesk"
  desc "Remote desktop software"
  homepage "https://github.com/your-repo/naiveRustdesk"

  depends_on macos: ">= :mojave"

  app "NaiveRustDesk.app"
end
```

### Package Verification
```bash
# Verify code signature
codesign --verify --verbose flutter/build/macos/Build/Products/Release/NaiveRustDesk.app

# Check notarization status
spctl --assess --verbose flutter/build/macos/Build/Products/Release/NaiveRustDesk.app

# Test installation
sudo installer -pkg NaiveRustDesk-AppStore.pkg -target /
```