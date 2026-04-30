#!/usr/bin/env bash

# Terminal colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Function to print section headers
print_section() {
  echo ""
  echo -e "${BOLD}${BLUE}==== $1 ====${NC}"
  echo ""
}

# Function to print setting application
apply_setting() {
  echo -e "${GREEN}✓${NC} $1"
}

# Function to print warnings
print_warning() {
  echo -e "${YELLOW}⚠️  $1${NC}"
}

# Clear the terminal and display script banner
clear
echo -e "${BOLD}${BLUE}"
echo "╔═══════════════════════════════════════════════╗"
echo "║              macOS Configuration              ║"
echo "╚═══════════════════════════════════════════════╝"
echo ""

# Close any open System Preferences panes
print_section "INITIALIZATION"
apply_setting "Closing System Preferences..."
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
apply_setting "Requesting administrator privileges..."
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
apply_setting "Setting up sudo keep-alive..."
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# System Audio Settings
print_section "AUDIO SETTINGS"
apply_setting "Disabling boot sound effects..."
sudo nvram SystemAudioVolume=" "

apply_setting "Increasing Bluetooth audio quality..."
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Visual Settings
print_section "VISUAL SETTINGS"
apply_setting "Disabling focus ring animation..."
defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false

apply_setting "Setting scrollbars to always show..."
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

apply_setting "Disabling menu bar transparency..."
defaults write com.apple.universalaccess reduceTransparency -bool true 2>/dev/null || print_warning "Could not disable menu bar transparency"

apply_setting "Increasing window resize speed..."
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Save/Print Dialog Settings
print_section "DIALOG SETTINGS"
apply_setting "Setting save panel to expanded by default..."
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

apply_setting "Setting print panel to expanded by default..."
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

apply_setting "Setting default save location to disk instead of iCloud..."
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

apply_setting "Setting printer app to quit when finished..."
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

apply_setting "Disabling application opening confirmation dialog..."
defaults write com.apple.LaunchServices LSQuarantine -bool false

# System UI Settings
print_section "SYSTEM UI SETTINGS"
apply_setting "Enabling system info display in login window clock..."
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Text Input Settings
print_section "TEXT INPUT SETTINGS"
apply_setting "Disabling automatic capitalization..."
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

apply_setting "Disabling smart dashes..."
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

apply_setting "Disabling automatic period substitution..."
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

apply_setting "Disabling smart quotes..."
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

apply_setting "Disabling auto-correct..."
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Trackpad and Keyboard Settings
print_section "TRACKPAD & KEYBOARD SETTINGS"
apply_setting "Enabling tap to click for trackpad..."
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

apply_setting "Enabling full keyboard access for all controls..."
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

apply_setting "Disabling press-and-hold for keys..."
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

apply_setting "Setting fast keyboard repeat rate..."
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Screenshot Settings
print_section "SCREENSHOT SETTINGS"
apply_setting "Disabling shadows in screenshots..."
defaults write com.apple.screencapture disable-shadow -bool true

# Finder Settings
print_section "FINDER SETTINGS"
apply_setting "Disabling Finder animations..."
defaults write com.apple.finder DisableAllAnimations -bool true

apply_setting "Showing Finder status bar..."
defaults write com.apple.finder ShowStatusBar -bool true

apply_setting "Showing Finder path bar..."
defaults write com.apple.finder ShowPathbar -bool true

apply_setting "Displaying full POSIX path in Finder window title..."
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

apply_setting "Disabling file extension change warning..."
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

apply_setting "Setting list view as default for Finder windows..."
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

apply_setting "Showing ~/Library folder..."
chflags nohidden ~/Library
xattr -d com.apple.FinderInfo ~/Library 2>/dev/null || true

apply_setting "Showing /Volumes folder..."
sudo chflags nohidden /Volumes

apply_setting "Expanding File Info panes..."
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true

# Dock Settings
print_section "DOCK SETTINGS"
apply_setting "Setting windows to minimize into application icons..."
defaults write com.apple.dock minimize-to-application -bool true

apply_setting "Enabling indicator lights for open applications in Dock..."
defaults write com.apple.dock show-process-indicators -bool true

apply_setting "Disabling Dock application opening animations..."
defaults write com.apple.dock launchanim -bool false

apply_setting "Removing auto-hiding Dock delay..."
defaults write com.apple.dock autohide-delay -float 0

apply_setting "Removing Dock hiding/showing animation..."
defaults write com.apple.dock autohide-time-modifier -float 0

apply_setting "Setting Dock to auto-hide..."
defaults write com.apple.dock autohide -bool true

apply_setting "Making hidden application Dock icons translucent..."
defaults write com.apple.dock showhidden -bool true

apply_setting "Disabling recent applications in Dock..."
defaults write com.apple.dock show-recents -bool false

# Theme Settings
print_section "THEME SETTINGS"
apply_setting "Downloading and installing Gruvbox Dark theme for iTerm2..."
curl -s -o gruvbox-dark.itermcolors https://raw.githubusercontent.com/morhetz/gruvbox-contrib/refs/heads/master/iterm2/gruvbox-dark.itermcolors && open gruvbox-dark.itermcolors

# Restart affected applications
print_section "FINISHING UP"
apply_setting "Restarting affected applications..."
for app in "Finder" "Dock" "SystemUIServer"; do
  killall "${app}" > /dev/null 2>&1
done

echo ""
echo -e "${BOLD}${GREEN}✅ macOS Configuration Completed!${NC}"
echo -e "${YELLOW}Note: Some changes may require a logout/restart to take effect.${NC}"
echo ""
