# Building NaiveRustDesk on Linux

This guide explains how to build NaiveRustDesk executables on Linux for desktop and mobile platforms.

## Prerequisites

### System Dependencies
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y git curl wget build-essential cmake gcc clang libgtk-3-dev libayatana-appindicator3-dev
sudo apt install -y libasound2-dev libpulse-dev libudev-dev libglib2.0-dev libgdk-pixbuf2.0-dev
sudo apt install -y libxdo-dev libxfixes-dev libxrandr-dev libxtst-dev libevdev-dev

# CentOS/RHEL/Fedora
sudo dnf install -y git curl wget gcc g++ cmake clang gtk3-devel libayatana-appindicator-gtk3-devel
sudo dnf install -y alsa-lib-devel pulseaudio-libs-devel systemd-devel glib2-devel gdk-pixbuf2-devel
sudo dnf install -y libxdo-devel libXfixes-devel libXrandr-devel libXtst-devel libevdev-devel

# Arch Linux
sudo pacman -S git curl wget base-devel cmake gcc clang gtk3 libayatana-appindicator
sudo pacman -S alsa-lib libpulse systemd glib2 gdk-pixbuf2 xdotool libxfixes libxrandr libxtst libevdev
```

### Rust Installation
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
rustup default stable
```

### Flutter Installation
```bash
# Download Flutter
cd /opt
sudo git clone https://github.com/flutter/flutter.git -b stable --depth 1
sudo chown -R $USER:$USER /opt/flutter

# Add to PATH
echo 'export PATH="$PATH:/opt/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# Verify installation
flutter doctor
```

### vcpkg Setup (for C++ dependencies)
```bash
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
./bootstrap-vcpkg.sh
export VCPKG_ROOT=$(pwd)
echo 'export VCPKG_ROOT=/path/to/vcpkg' >> ~/.bashrc

# Install required packages
./vcpkg install libvpx libyuv opus aom
```

## Building

### 1. Clone the Repository
```bash
git clone https://github.com/your-repo/naiveRustdesk.git
cd naiveRustdesk
```

### 2. Build Desktop Application (Flutter)
```bash
# Build debug version
python3 build.py --flutter

# Build release version
python3 build.py --flutter --release

# Build with hardware codec support
python3 build.py --flutter --hwcodec

# Alternative: Direct Flutter build
cd flutter
flutter build linux --release
```

### 3. Build Rust Backend Only
```bash
# Debug build
cargo build

# Release build
cargo build --release

# With hardware codec
cargo build --release --features hwcodec
```

### 4. Build for Different Distributions

#### AppImage (Universal Linux Package)
```bash
# Install AppImageTool
wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage

# Build AppImage
python3 build.py --flutter --release
# The build script will create an AppImage in the target directory
```

#### Debian Package
```bash
# Install build dependencies
sudo apt install -y dpkg-dev fakeroot

# Build .deb package
python3 build.py --flutter --release --deb
```

#### RPM Package
```bash
# Install build dependencies
sudo dnf install -y rpm-build rpmlint

# Build .rpm package
python3 build.py --flutter --release --rpm
```

### 5. Mobile Builds (Android)
```bash
cd flutter

# Install Android dependencies
flutter doctor --android-licenses

# Build APK
flutter build apk --release

# Build App Bundle (for Google Play)
flutter build appbundle --release

# Build for specific architecture
flutter build apk --release --target-platform android-arm64
```

## Build Outputs

### Desktop Linux
- **Executable**: `flutter/build/linux/x64/release/bundle/naiveRustdesk`
- **Complete Bundle**: `flutter/build/linux/x64/release/bundle/` (contains all required files)

### Android
- **APK**: `flutter/build/app/outputs/flutter-apk/app-release.apk`
- **App Bundle**: `flutter/build/app/outputs/bundle/release/app-release.aab`

## Running the Application

### Desktop
```bash
# Run from build directory
cd flutter/build/linux/x64/release/bundle
./naiveRustdesk

# Or install system-wide and run
sudo cp -r flutter/build/linux/x64/release/bundle/* /opt/naiveRustdesk/
sudo ln -s /opt/naiveRustdesk/naiveRustdesk /usr/local/bin/naiveRustdesk
naiveRustdesk
```

### Android
```bash
# Install on connected device
flutter install

# Or install APK manually
adb install flutter/build/app/outputs/flutter-apk/app-release.apk
```

## Troubleshooting

### Common Issues

#### Missing Dependencies
```bash
# If you get library errors, install missing packages:
sudo apt install -y libc6-dev libstdc++6

# For older Ubuntu versions:
sudo apt install -y libssl1.1
```

#### vcpkg Issues
```bash
# Make sure VCPKG_ROOT is set correctly
echo $VCPKG_ROOT

# Reinstall packages if needed
cd $VCPKG_ROOT
./vcpkg remove libvpx libyuv opus aom
./vcpkg install libvpx libyuv opus aom
```

#### Flutter Issues
```bash
# Clean and rebuild
cd flutter
flutter clean
flutter pub get
flutter build linux --release
```

#### Build Script Issues
```bash
# If Python build script fails, try manual steps:
cd flutter
flutter clean
flutter pub get
flutter build linux --release --verbose
```

### Performance Optimization

#### For better performance, build with optimizations:
```bash
# Enable hardware acceleration
python3 build.py --flutter --release --hwcodec --vram

# Link-time optimization
RUSTFLAGS="-C lto=fat" cargo build --release
```

#### For debugging:
```bash
# Build with debug symbols
python3 build.py --flutter --debug

# Run with debugging
RUST_LOG=debug ./naiveRustdesk
```

## Distribution

### Creating Installation Package
```bash
# Create tar.gz distribution
cd flutter/build/linux/x64/release
tar -czf naiveRustdesk-linux-x64.tar.gz bundle/

# Create installer script
cat > install.sh << 'EOF'
#!/bin/bash
sudo mkdir -p /opt/naiveRustdesk
sudo tar -xzf naiveRustdesk-linux-x64.tar.gz -C /opt/naiveRustdesk --strip-components=1
sudo ln -sf /opt/naiveRustdesk/naiveRustdesk /usr/local/bin/naiveRustdesk
echo "NaiveRustDesk installed successfully!"
EOF
chmod +x install.sh
```

### System Integration
```bash
# Create desktop entry
cat > ~/.local/share/applications/naiveRustdesk.desktop << 'EOF'
[Desktop Entry]
Name=NaiveRustDesk
Comment=Remote Desktop Software
Exec=/usr/local/bin/naiveRustdesk
Icon=/opt/naiveRustdesk/data/flutter_assets/assets/icon.png
Terminal=false
Type=Application
Categories=Network;RemoteAccess;
EOF
```