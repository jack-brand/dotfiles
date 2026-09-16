#!/usr/bin/env bash

# Credit: <https://github.com/bahamas10/dotfiles> <https://github.com/mathiasbynens/dotfiles/blob/master/.osx>

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"

defaults() {
    echo defaults "$@"
    command defaults "$@"
}

# Keyboard
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticCapitalizationEnabled -bool false
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2
defaults write -g AppleMiniaturizeOnDoubleClick -bool false
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

# Global
defaults write -g PMPrintingExpandedStateForPrint -bool true
defaults write -g PMPrintingExpandedStateForPrint2 -bool true
defaults write -g NSDocumentSaveNewDocumentsToCloud -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g AppleKeyboardUIMode -int 3  # full keyboard access for controls, e.g. tab in modal dialogs
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

# Languages
defaults write .GlobalPreferences_m AppleLanguages -array "en-ZA" "en-GB"

# Trackpad
defaults write com.apple.AppleMultitouchTrackpad ActuateDetents -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad DragLock -bool false
defaults write com.apple.AppleMultitouchTrackpad Dragging -bool false
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 0
defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -bool false
defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerPinchGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadHandResting -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadHorizScroll -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadMomentumScroll -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadScroll -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad USBMouseStopsTrackpad -bool false
defaults write com.apple.AppleMultitouchTrackpad UserPreferences -bool true

# Printer
defaults write com.apple.print.PrintingPrefs 'Quit When Finished' -bool true

# Mission Control
defaults write com.apple.dock mru-spaces -bool false

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock orientation -string bottom
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock showhidden -bool true
defaults write com.apple.dock mineffect -string scale
defaults write com.apple.dock showAppExposeGestureEnabled -bool false
defaults write com.apple.dock showMissionControlGestureEnabled -bool true

# Screenshot
defaults write com.apple.screencapture include-date -bool true
defaults write com.apple.screencapture style -string selection

# Hot corners
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.dock wvous-br-corner -int 0
defaults write com.apple.dock wvous-br-modifier -int 0
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-bl-modifier -int 0

# Preview
defaults write com.apple.Preview ApplePersistence -bool false  # disable autosave

# Terminal
defaults write com.apple.Terminal CopyAttributesProfile com.apple.Terminal.no-attributes
defaults write com.apple.Terminal 'Startup Window Settings' -string Basic
defaults write com.apple.Terminal 'Default Window Settings' -string Basic
defaults write com.apple.Terminal NewTabSettingsBehavior -int 1
defaults write com.apple.Terminal NewTabWorkingDirectoryBehavior -int 1

# Finder
chflags nohidden ~/Library
defaults write -g AppleShowAllExtensions -bool true
defaults write -g AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowSidebar -bool false
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowRecentTags -bool false
defaults write com.apple.finder ShowTabView -bool true
defaults write com.apple.finder ShowToolbar -bool false
defaults write com.apple.finder _FXSortFoldersFirst -bool false
defaults write com.apple.finder _FXShowPosixPathInTitle -bool false
defaults write com.apple.finder WarnOnEmptyTrash -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.finder NewWindowTarget -string PfHm
defaults write com.apple.finder NewWindowTargetPath -string "file:///$HOME"
defaults write com.apple.finder FXDefaultSearchScope -string SCcf
defaults write com.apple.finder FXRemoveOldTrashItems -bool false

# Window Manager
defaults write com.apple.WindowManager AppWindowGroupingBehavior -bool true
defaults write com.apple.WindowManager AutoHide -bool true
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool false
defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool false
defaults write com.apple.WindowManager EnableTopTilingByEdgeDrag -bool false
defaults write com.apple.WindowManager HideDesktop -bool true
defaults write com.apple.WindowManager StageManagerHideWidgets -bool true
defaults write com.apple.WindowManager StandardHideWidgets -bool true

# HIToolbox
defaults write com.apple.HIToolbox AppleDictationAutoEnable -bool false

# Clock
defaults write com.apple.menuextra.clock FlashDateSeparators -bool false
defaults write com.apple.menuextra.clock IsAnalog -bool false
defaults write com.apple.menuextra.clock Show24Hour -bool true
defaults write com.apple.menuextra.clock ShowAMPM -bool true
defaults write com.apple.menuextra.clock ShowDate -bool true
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true
defaults write com.apple.menuextra.clock ShowSeconds -bool true

# External apps
app_exists() {
    [[ -d "/Applications/$1.app" || -d "$HOME/Applications/$1.app" ]]
}

if app_exists "Rectangle"; then
    defaults write com.knollsoft.Rectangle doubleClickTitleBar -bool false
    defaults write com.knollsoft.Rectangle landscapeSnapAreas -string "[]"
    defaults write com.knollsoft.Rectangle larger -dict
    defaults write com.knollsoft.Rectangle largerWidth -dict \
        keyCode -int 24 \
        modifierFlags -int 786432
    defaults write com.knollsoft.Rectangle smaller -dict
    defaults write com.knollsoft.Rectangle smallerWidth -dict \
        keyCode -int 27 \
        modifierFlags -int 786432
    defaults write com.knollsoft.Rectangle showAdditionalSizesInMenu -bool true
fi

# Spotlight
defaults write com.apple.lookup lookupEnabled -dict-add suggestionsEnabled -bool no  # disable telemetry

echo 'Restarting Dock and Finder'
killall Dock Finder

true

