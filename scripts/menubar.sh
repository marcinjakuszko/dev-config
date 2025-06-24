#!/bin/bash

# macOS Control Center Icons Configuration Script
# Ensures Bluetooth, Sound, and Now Playing icons are always visible

echo "Configuring macOS Control Center to show Bluetooth, Sound, and Now Playing icons..."

# Set Bluetooth to always show in Control Center
defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool true
defaults write com.apple.controlcenter "NSStatusItem Preferred Position Bluetooth" -int 1000

# Set Sound (Volume) to always show in Control Center  
defaults write com.apple.controlcenter "NSStatusItem Visible Sound" -bool true
defaults write com.apple.controlcenter "NSStatusItem Preferred Position Sound" -int 1001

# Set Now Playing to always show in Control Center
defaults write com.apple.controlcenter "NSStatusItem Visible NowPlaying" -bool true
defaults write com.apple.controlcenter "NSStatusItem Preferred Position NowPlaying" -int 1002

# Alternative method using the newer preference key format (for newer macOS versions)
defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist Bluetooth -int 18
defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist Sound -int 18
defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist NowPlaying -int 18

# Restart Control Center to apply changes
echo "Restarting Control Center to apply changes..."
killall ControlCenter 2>/dev/null || true

# Wait a moment for the restart
sleep 2

# Also restart SystemUIServer for good measure (handles some menu bar items)
killall SystemUIServer 2>/dev/null || true

echo "✅ Control Center configuration complete!"
echo "Bluetooth, Sound, and Now Playing icons should now be visible in Control Center."
echo ""
echo "Note: If the icons don't appear immediately, try:"
echo "1. Opening Control Center manually"
echo "2. Logging out and back in"
echo "3. Restarting your Mac"
echo ""
echo "You can also manually configure these in:"
echo "System Settings > Control Center > and set each module to 'Show in Menu Bar'"