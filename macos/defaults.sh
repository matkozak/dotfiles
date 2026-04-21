#!/bin/sh
# macOS system defaults
# Run once after a fresh install. Some settings require a logout/restart.
# Usage: just macos

set -eu

echo "Applying macOS defaults..."

# Dock
#
echo "  Dock"

defaults write com.apple.dock orientation -string "left"
defaults write com.apple.dock autohide -bool false
defaults write com.apple.dock tilesize -int 60
defaults write com.apple.dock show-recents -bool false

# Finder
#
echo "  Finder"

# clmv = columns, Nlsv = list, icnv = icon, Flwv = gallery
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
defaults write com.apple.finder AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Trackpad
#
echo "  Trackpad"

# tap to click: off
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool false
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool false

# "natural" scroll: off
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Global
#
echo "  Global"

# smart quotes and smart dashes: on
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool true
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool true
# instant window resize animation
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
# save to disk (not iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
# don't litter .DS_Store on network/USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Keyboard
#
echo "  Keyboard"

# Key repeat rate (lower = faster; 6 is macOS default)
defaults write NSGlobalDomain KeyRepeat -int 5
# Initial repeat delay (lower = shorter; 68 is macOS default)
defaults write NSGlobalDomain InitialKeyRepeat -int 30

# Mission Control
#
echo "  Mission Control"

# don't rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

echo "  Hot corners"

# actions:
#   1=disabled, 2=Mission Control, 3=App Windows, 4=Desktop, 5=Screen Saver,
#   10=Sleep Display, 11=Launchpad, 13=Lock Screen, 14=Quick Note
# modifiers:
#   0=none, 131072=Shift, 262144=Control, 524288=Option, 1048576=Command
defaults write com.apple.dock wvous-tr-corner -int 2  # Mission Control
defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.dock wvous-br-corner -int 4  # Desktop
defaults write com.apple.dock wvous-br-modifier -int 0

# Restart affected apps
#
echo "  Restarting Dock and Finder..."
killall Dock   2>/dev/null || true
killall Finder 2>/dev/null || true

echo "Done. Some settings require a logout or restart to take effect."

# Manual changes reminder
#
echo ""
echo "Manual steps:"
echo "  - Disable Ctrl+Space input source shortcut:"
echo "    System Settings > Keyboard > Keyboard Shortcuts > Input Sources"
echo "  - Remap modifiers (Ctrl>Cmd>Opt>Ctrl rotation):"
echo "    System Settings > Keyboard > Keyboard Shortcuts > Modifier Keys"
