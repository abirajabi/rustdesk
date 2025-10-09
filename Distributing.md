## to build
│   cd /Users/macbook/Data/Work/Freelance/rustdesk && VCPKG_ROOT=/Users/macbook/vcpkg MACOSX_DEPLOYMENT_TARGET=10.14 cargo build --features      │
│   flutter --release 2>&1 | head -100

Based on the RustDesk repository structure and the macOS build you've completed, here's what you should release for macOS:

For macOS Distribution

1. The .app Bundle (Primary Release Artifact)

Location: /Users/macbook/Data/Work/Freelance/rustdesk/flutter/build/macos/Build/Products/Release/R-connect.app

This is your main application bundle. However, you have two distribution options:

Option A: DMG File (Recommended for Public Release)

A DMG (disk image) is the standard way to distribute macOS apps. According to the res/osx-dist.sh script, this repository uses create-dmg to
package the app.

Steps to create a DMG:
1. Install create-dmg if not already installed: brew install create-dmg
2. Create the DMG with a command like:
   create-dmg \
   --icon "R-connect.app" 200 190 \
   --hide-extension "R-connect.app" \
   --window-size 800 400 \
   --app-drop-link 600 185 \
   R-connect-1.4.2.dmg \
   ./flutter/build/macos/Build/Products/Release/R-connect.app

What users get: A .dmg file they can double-click, which opens a window where they drag the app to their Applications folder.

Option B: ZIP Archive (Simple Alternative)

Compress the .app bundle into a ZIP file:
cd /Users/macbook/Data/Work/Freelance/rustdesk/flutter/build/macos/Build/Products/Release/
zip -r R-connect-1.4.2-macos.zip R-connect.app

What users get: A .zip file they extract and move the app to Applications manually.

2. Code Signing Considerations

According to the osx-dist.sh script, this repository normally:
- Code signs the app with a Developer ID
- Notarizes with Apple for Gatekeeper approval

Without these, users will see security warnings. For internal/testing use, they can right-click → Open to bypass. For public release, you
should:
- Sign with your Apple Developer certificate
- Notarize with Apple (required for macOS 10.15+)

Summary - What to Release

For public distribution of this RustDesk fork (R-connect):

✅ Release this: R-connect-1.4.2.dmg (after creating it and optionally signing/notarizing)

OR

✅ Release this: R-connect-1.4.2-macos.zip (compressed .app bundle)

Include in your release notes:
- Minimum macOS version supported
- Whether it's signed/notarized (if not, provide installation instructions)
- Installation instructions (drag to Applications, allow in Security preferences if needed)
