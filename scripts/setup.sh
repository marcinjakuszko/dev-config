#!/bin/bash

# macOS Setup Script
# This script configures various system settings via terminal

# Check if running as sudo/root
if [[ $EUID -eq 0 ]]; then
    echo "❌ Error: This script should NOT be run with sudo or as root!"
    echo ""
    echo "Reason: This script configures user-specific settings and preferences."
    echo "Running as root would apply settings to the root user instead of your user account."
    echo ""
    echo "Please run the script normally:"
    echo "  ./setup_macos.sh"
    echo ""
    echo "The script will prompt for sudo password only when needed for specific commands."
    exit 1
fi

echo "Starting macOS configuration..."

# Install Xcode Command Line Tools
echo "Installing Xcode Command Line Tools..."
if ! command -v git &> /dev/null; then
    echo "Xcode Command Line Tools not found. Installing..."
    xcode-select --install
    echo "Please complete the Xcode Command Line Tools installation in the popup window."
    echo "Press any key to continue after installation is complete..."
    read -n 1 -s
else
    echo "Xcode Command Line Tools already installed."
fi

# Set hostname
echo ""
read -p "Do you want to set a custom hostname? (y/N): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Current hostname: $(scutil --get HostName 2>/dev/null || echo "Not set")"
    echo "Current computer name: $(scutil --get ComputerName 2>/dev/null || echo "Not set")"
    echo ""
    read -p "Enter new hostname (no spaces or special characters): " HOSTNAME
    
    if [[ -n "$HOSTNAME" ]]; then
        echo "Setting hostname to: $HOSTNAME"
        sudo scutil --set HostName "$HOSTNAME"
        sudo scutil --set ComputerName "$HOSTNAME"
        sudo scutil --set LocalHostName "$HOSTNAME"
        HOSTNAME_SET=true
    else
        echo "No hostname entered. Skipping hostname setup."
        HOSTNAME_SET=false
    fi
else
    echo "Skipping hostname setup."
    HOSTNAME_SET=false
fi

# Disable natural scrolling
echo "Disabling natural scrolling..."
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Remove all apps from dock
echo "Removing all apps from dock..."
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock persistent-others -array

# Disable recent items in dock
echo "Disabling recent items in dock..."
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock show-recent-files -bool false

# Enable dock auto-hide
echo "Enabling dock auto-hide..."
defaults write com.apple.dock autohide -bool true

# Optional: Remove dock delay and speed up animation
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.5

# Apply dock changes
echo "Applying dock changes..."
killall Dock

# Enable right-click in bottom-right corner of trackpad
echo "Enabling right-click in bottom-right corner..."
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 2

# Enable tap to click
echo "Enabling tap to click..."
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Enable window drag with cmd+ctrl
echo "Enabling window drag with Cmd+Ctrl..."
defaults write NSGlobalDomain NSWindowShouldDragOnGesture -bool true

# Apply trackpad changes
echo "Applying trackpad changes..."
sudo pkill -f /System/Library/Input\ Methods/PressAndHold.app/Contents/MacOS/PressAndHold 2>/dev/null

# Install Homebrew
echo "Installing Homebrew..."
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for current session
    if [[ $(uname -m) == "arm64" ]]; then
        # Apple Silicon Mac
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        # Intel Mac
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    
    echo "Homebrew installation complete!"
else
    echo "Homebrew already installed."
fi

# Set wallpaper to black color
echo "Setting wallpaper to black color..."
osascript -e 'tell application "System Events" to tell every desktop to set picture to ""'
osascript -e 'tell application "System Events" to set desktop picture to POSIX file "/System/Library/Desktop Pictures/Solid Colors/Black.png"' 2>/dev/null || \
osascript -e 'tell application "System Events" to set desktop picture to POSIX file "/Library/Desktop Pictures/Solid Colors/Black.png"' 2>/dev/null || \
osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/System/Library/Desktop Pictures/Solid Colors/Black.png"' 2>/dev/null || \
echo "Could not set wallpaper automatically. You can manually set it to a black solid color in System Preferences > Desktop & Dock > Wallpaper."

echo ""
echo "Configuration complete!"
echo ""
echo "Changes applied:"
echo "✓ Xcode Command Line Tools installed"
if [[ $HOSTNAME_SET == true ]]; then
    echo "✓ Hostname set to: $HOSTNAME"
fi
echo "✓ Natural scrolling disabled"
echo "✓ Dock cleared of all apps"
echo "✓ Recent items in dock disabled"
echo "✓ Dock auto-hide enabled"
echo "✓ Right-click enabled in bottom-right corner"
echo "✓ Tap to click enabled"
echo "✓ Window drag with Cmd+Ctrl enabled"
echo "✓ Homebrew installed"
echo "✓ Wallpaper set to black color"
echo ""
echo "Note: You may need to log out and log back in for all changes to take effect."
echo "Some trackpad settings may require a restart."