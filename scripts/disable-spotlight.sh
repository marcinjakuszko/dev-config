#!/bin/bash

# Script to disable Command+Space shortcut for Spotlight on macOS
# This script modifies the system preferences to remove the keyboard shortcut

echo "Disabling Command+Space shortcut for Spotlight..."

# Method 1: Using defaults command to disable Spotlight shortcuts
# This disables the "Show Spotlight search" shortcut
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "
<dict>
  <key>enabled</key>
  <false/>
  <key>value</key>
  <dict>
    <key>type</key>
    <string>standard</string>
    <key>parameters</key>
    <array>
      <integer>32</integer>
      <integer>49</integer>
      <integer>1048576</integer>
    </array>
  </dict>
</dict>"

# This disables the "Show Finder search window" shortcut  
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 "
<dict>
  <key>enabled</key>
  <false/>
  <key>value</key>
  <dict>
    <key>type</key>
    <string>standard</string>
    <key>parameters</key>
    <array>
      <integer>32</integer>
      <integer>49</integer>
      <integer>1572864</integer>
    </array>
  </dict>
</dict>"

echo "Spotlight Command+Space shortcut has been disabled."
echo "You may need to restart your Mac or log out and back in for changes to take effect."
echo ""
echo "To re-enable the shortcut later, you can:"
echo "1. Go to System Preferences > Keyboard > Shortcuts > Spotlight"
echo "2. Check the boxes next to 'Show Spotlight search' and 'Show Finder search window'"
echo "3. Or run this command to re-enable:"
echo "   defaults delete com.apple.symbolichotkeys AppleSymbolicHotKeys"