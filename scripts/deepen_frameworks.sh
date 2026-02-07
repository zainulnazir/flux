#!/bin/bash

# Source directory (DerivedData checkout)
SOURCE_DIR="/Users/zainulnazir/Library/Developer/Xcode/DerivedData/flux-aibuqtwuvdgdcnehxumnfyerxreh/SourcePackages/checkouts/MPVKit/Sources"
# Destination directory
DEST_DIR="/Users/zainulnazir/flux-mac-app/flux/flux/LocalPackages/MPVKit/Frameworks"

mkdir -p "$DEST_DIR"

echo "Copying and deepening frameworks..."

# Find all macOS frameworks
find "$SOURCE_DIR" -name "*.framework" -type d | grep "macos-arm64_x86_64" | while read framework_path; do
    framework_name=$(basename "$framework_path")
    binary_name="${framework_name%.*}"
    dest_path="$DEST_DIR/$framework_name"
    
    echo "Processing $framework_name..."
    
    # Remove existing
    rm -rf "$dest_path"
    mkdir -p "$dest_path/Versions/A/Resources"
    
    # Copy binary
    cp "$framework_path/$binary_name" "$dest_path/Versions/A/$binary_name"
    
    # Copy Info.plist if exists
    if [ -f "$framework_path/Info.plist" ]; then
        cp "$framework_path/Info.plist" "$dest_path/Versions/A/Resources/Info.plist"
    fi
    
    # Copy Headers if exists
    if [ -d "$framework_path/Headers" ]; then
        cp -R "$framework_path/Headers" "$dest_path/Versions/A/Headers"
    fi
    
    # Copy Modules if exists
    if [ -d "$framework_path/Modules" ]; then
        cp -R "$framework_path/Modules" "$dest_path/Versions/A/Modules"
    fi
    
    # Create symlinks
    cd "$dest_path"
    ln -sf A Versions/Current
    ln -sf Versions/Current/$binary_name $binary_name
    ln -sf Versions/Current/Resources Resources
    if [ -d "Versions/A/Headers" ]; then
        ln -sf Versions/Current/Headers Headers
    fi
    if [ -d "Versions/A/Modules" ]; then
        ln -sf Versions/Current/Modules Modules
    fi
    cd - > /dev/null
done

echo "Done!"
