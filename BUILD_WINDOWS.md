# Building R-connect on Windows

This guide explains how to build R-connect executables on Windows for desktop and mobile platforms.

## Prerequisites

### System Requirements
- Windows 10 version 1903 or later (64-bit)
- Visual Studio 2019 or 2022 with C++ build tools
- At least 8 GB RAM and 20 GB free disk space

### Install Visual Studio
1. Download Visual Studio Community (free) from https://visualstudio.microsoft.com/
2. During installation, make sure to select:
   - **Desktop development with C++** workload
   - **Windows 10/11 SDK** (latest version)
   - **CMake tools for C++**
   - **Git for Windows**

### Install Git (if not installed with Visual Studio)
```cmd
# Download and install Git from https://git-scm.com/download/win
# Or use winget
winget install Git.Git
```

### Install Rust
```cmd
# Download and run rustup-init.exe from https://rustup.rs/
# Or use the following PowerShell command:
Invoke-WebRequest -Uri "https://win.rustup.rs/x86_64" -OutFile "rustup-init.exe"
.\rustup-init.exe

# Restart your terminal, then verify installation
rustc --version
cargo --version
```

### Install Flutter
```cmd
# Download Flutter SDK from https://docs.flutter.dev/get-started/install/windows
# Extract to C:\flutter (or your preferred location)

# Add to PATH in System Environment Variables:
# C:\flutter\bin

# Verify installation
flutter doctor

# Accept Android licenses (for mobile development)
flutter doctor --android-licenses
```

### Install Python
```cmd
# Download Python 3.8+ from https://python.org/downloads/
# Or use winget
winget install Python.Python.3.11

# Verify installation
python --version
```

### Install vcpkg (for C++ dependencies)
```cmd
# Open Command Prompt as Administrator
cd C:\
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
.\bootstrap-vcpkg.bat

# Set environment variable
setx VCPKG_ROOT "C:\vcpkg" /M

# Install required packages
vcpkg install libvpx:x64-windows libyuv:x64-windows opus:x64-windows aom:x64-windows
vcpkg integrate install
```

### Download Sciter Library (for legacy UI)
1. Visit https://sciter.com/download/
2. Download Windows SDK
3. Extract and note the path for later use

## Building

### 1. Clone the Repository
```cmd
git clone https://github.com/your-repo/naiveRustdesk.git
cd naiveRustdesk
```

### 2. Build Desktop Application (Flutter)

#### Using Build Script
```cmd
# Build debug version
python build.py --flutter

# Build release version
python build.py --flutter --release

# Build with hardware codec support
python build.py --flutter --release --hwcodec

# Build with VRAM optimization (Windows-specific feature)
python build.py --flutter --release --vram
```

#### Manual Flutter Build
```cmd
cd flutter

# Clean previous builds
flutter clean
flutter pub get

# Build debug
flutter build windows --debug

# Build release
flutter build windows --release
```

### 3. Build Rust Backend Only
```cmd
# Debug build
cargo build

# Release build
cargo build --release

# With hardware codec
cargo build --release --features hwcodec

# With VRAM feature (Windows only)
cargo build --release --features vram

# With all Windows-specific features
cargo build --release --features "hwcodec,vram"
```

### 4. Build for Android (from Windows)
```cmd
cd flutter

# Make sure Android development is set up
flutter doctor

# Build APK
flutter build apk --release

# Build App Bundle (for Google Play)
flutter build appbundle --release

# Build for specific architecture
flutter build apk --release --target-platform android-arm64
```

### 5. Build with Different Configurations

#### Debug Build with Console
```cmd
# For debugging, build with console output
set RUSTFLAGS=-C link-args="/SUBSYSTEM:CONSOLE"
cargo build
```

#### Optimized Release Build
```cmd
# Maximum optimization
set RUSTFLAGS=-C target-cpu=native -C opt-level=3
cargo build --release
```

#### Static Linking (for portable executable)
```cmd
# Build with static linking to avoid DLL dependencies
set RUSTFLAGS=-C target-feature=+crt-static
cargo build --release
```

## Build Outputs

### Desktop Windows
- **Executable**: `flutter\build\windows\runner\Release\naive_rust_desk.exe`
- **Complete Bundle**: `flutter\build\windows\runner\Release\` (contains all required files)

### Android
- **APK**: `flutter\build\app\outputs\flutter-apk\app-release.apk`
- **App Bundle**: `flutter\build\app\outputs\bundle\release\app-release.aab`

## Running the Application

### Desktop
```cmd
# Run from build directory
cd flutter\build\windows\runner\Release
naive_rust_desk.exe

# Or create a shortcut on desktop
# Target: C:\path\to\naiveRustdesk\flutter\build\windows\runner\Release\naive_rust_desk.exe
# Start in: C:\path\to\naiveRustdesk\flutter\build\windows\runner\Release
```

### Install as Windows Service
```cmd
# Run as administrator
cd flutter\build\windows\runner\Release
naive_rust_desk.exe --install-service

# Start the service
net start naiveRustdesk

# Stop the service
net stop naiveRustdesk

# Uninstall the service
naive_rust_desk.exe --uninstall-service
```

## Creating Installer

### Using NSIS (Nullsoft Scriptable Install System)
```cmd
# Install NSIS from https://nsis.sourceforge.io/

# Create installer script (naiveRustdesk-installer.nsi)
# ... (see installer script below)

# Compile installer
"C:\Program Files (x86)\NSIS\makensis.exe" naiveRustdesk-installer.nsi
```

#### Sample NSIS Installer Script
```nsis
; naiveRustdesk-installer.nsi
!define APP_NAME "R-connect"
!define COMP_NAME "YourCompany"
!define VERSION "1.4.2"
!define DESCRIPTION "Remote Desktop Software"
!define INSTALLER_NAME "R-connect-Setup.exe"
!define MAIN_APP_EXE "naive_rust_desk.exe"
!define INSTALL_TYPE "SetShellVarContext all"
!define REG_ROOT "HKLM"
!define REG_APP_PATH "Software\Microsoft\Windows\CurrentVersion\App Paths\${MAIN_APP_EXE}"
!define UNINSTALL_PATH "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"

Name "${APP_NAME}"
Caption "${APP_NAME} ${VERSION}"
OutFile "${INSTALLER_NAME}"
BrandingText "${APP_NAME}"
XPStyle on
InstallDirRegKey "${REG_ROOT}" "${REG_APP_PATH}" ""
InstallDir "$PROGRAMFILES64\${APP_NAME}"

Section -MainProgram
${INSTALL_TYPE}
SetOverwrite ifnewer
SetOutPath "$INSTDIR"
File /r "flutter\build\windows\runner\Release\*"
SectionEnd

Section -Icons_Reg
SetOutPath "$INSTDIR"
WriteUninstaller "$INSTDIR\uninstall.exe"

!ifdef REG_START_MENU
!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
CreateDirectory "$SMPROGRAMS\$SM_Folder"
CreateShortCut "$SMPROGRAMS\$SM_Folder\${APP_NAME}.lnk" "$INSTDIR\${MAIN_APP_EXE}"
CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\${MAIN_APP_EXE}"
CreateShortCut "$SMPROGRAMS\$SM_Folder\Uninstall ${APP_NAME}.lnk" "$INSTDIR\uninstall.exe"
!insertmacro MUI_STARTMENU_WRITE_END
!endif

WriteRegStr ${REG_ROOT} "${REG_APP_PATH}" "" "$INSTDIR\${MAIN_APP_EXE}"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}" "DisplayName" "${APP_NAME}"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}" "UninstallString" "$INSTDIR\uninstall.exe"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}" "DisplayIcon" "$INSTDIR\${MAIN_APP_EXE}"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}" "DisplayVersion" "${VERSION}"
WriteRegStr ${REG_ROOT} "${UNINSTALL_PATH}" "Publisher" "${COMP_NAME}"
SectionEnd

Section Uninstall
${INSTALL_TYPE}
Delete "$INSTDIR\${MAIN_APP_EXE}"
Delete "$INSTDIR\uninstall.exe"
RmDir /r "$INSTDIR"
DeleteRegKey ${REG_ROOT} "${REG_APP_PATH}"
DeleteRegKey ${REG_ROOT} "${UNINSTALL_PATH}"
SectionEnd
```

### Using Inno Setup
```cmd
# Install Inno Setup from https://jrsoftware.org/isinfo.php

# Create setup script (naiveRustdesk-setup.iss)
# Compile with Inno Setup Compiler
```

### Using WiX Toolset (MSI installer)
```cmd
# Install WiX Toolset from https://wixtoolset.org/

# Create WiX source files
# Build MSI package
candle naiveRustdesk.wxs
light naiveRustdesk.wixobj -o R-connect.msi
```

## Troubleshooting

### Common Issues

#### Missing MSVC Runtime
```cmd
# Download and install Microsoft Visual C++ Redistributable
# https://docs.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist

# Or include in your installer
```

#### Missing DLL Dependencies
```cmd
# Check dependencies with Dependency Walker or similar tool
# Copy required DLLs to output directory

# For common missing DLLs:
copy "C:\Windows\System32\vcruntime140.dll" flutter\build\windows\runner\Release\
copy "C:\Windows\System32\msvcp140.dll" flutter\build\windows\runner\Release\
```

#### Build Errors
```cmd
# Clean build environment
cargo clean
cd flutter && flutter clean

# Rebuild
flutter pub get
python build.py --flutter --release
```

#### vcpkg Issues
```cmd
# Reinstall packages
cd C:\vcpkg
vcpkg remove libvpx:x64-windows libyuv:x64-windows opus:x64-windows aom:x64-windows
vcpkg install libvpx:x64-windows libyuv:x64-windows opus:x64-windows aom:x64-windows
```

#### Permission Issues
```cmd
# Run Command Prompt as Administrator
# Ensure antivirus is not blocking builds
# Add build directories to antivirus exclusions
```

### Performance Optimization

#### For better performance:
```cmd
# Enable hardware acceleration
python build.py --flutter --release --hwcodec --vram

# Use link-time optimization
set RUSTFLAGS=-C lto=fat
cargo build --release
```

#### For debugging:
```cmd
# Build with debug symbols
python build.py --flutter --debug

# Run with debugging
set RUST_LOG=debug
flutter\build\windows\runner\Debug\naive_rust_desk.exe
```

## Code Signing and Distribution

### Code Signing (for trusted distribution)
```cmd
# Obtain code signing certificate from trusted CA
# Sign the executable
signtool sign /f "certificate.pfx" /p "password" /t "http://timestamp.digicert.com" flutter\build\windows\runner\Release\naive_rust_desk.exe

# Verify signature
signtool verify /v flutter\build\windows\runner\Release\naive_rust_desk.exe
```

### Creating Portable Version
```cmd
# Copy all files to a single directory
mkdir R-connect-Portable
xcopy flutter\build\windows\runner\Release\* R-connect-Portable\ /E

# Create portable marker file
echo. > R-connect-Portable\portable.txt

# Create ZIP archive
powershell Compress-Archive -Path R-connect-Portable -DestinationPath R-connect-Portable.zip
```

### Windows Store Package
```cmd
# Install Windows App SDK
# Create MSIX package for Microsoft Store

# Use Visual Studio or command line tools
makeappx pack /d "flutter\build\windows\runner\Release" /p "R-connect.msix"

# Sign MSIX package
signtool sign /fd SHA256 /a /f "certificate.pfx" /p "password" "R-connect.msix"
```

### Distribution Options

1. **Direct Download**: Host the installer/portable version on your website
2. **Windows Store**: Submit MSIX package to Microsoft Store
3. **Chocolatey**: Create Chocolatey package for easy installation
4. **Winget**: Submit to Windows Package Manager Community Repository
5. **GitHub Releases**: Use GitHub Actions for automated builds and releases

### Automated Build with GitHub Actions
```yaml
# .github/workflows/build-windows.yml
name: Build Windows
on: [push, pull_request]
jobs:
  build:
    runs-on: windows-latest
    steps:
    - uses: actions/checkout@v3
    - uses: actions/setup-python@v4
      with:
        python-version: '3.11'
    - uses: dtolnay/rust-toolchain@stable
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.13.0'
    - name: Install dependencies
      run: |
        vcpkg install libvpx:x64-windows libyuv:x64-windows opus:x64-windows aom:x64-windows
    - name: Build
      run: python build.py --flutter --release
    - name: Upload artifacts
      uses: actions/upload-artifact@v3
      with:
        name: windows-build
        path: flutter/build/windows/runner/Release/
```