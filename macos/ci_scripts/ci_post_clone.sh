#!/bin/sh
# Xcode Cloud only clones the git repo — Flutter is not preinstalled and
# macos/Flutter/ephemeral/ (gitignored) is never generated. Without it,
# macos/Podfile can't run (it reads FLUTTER_ROOT from Flutter-Generated.xcconfig)
# and the xcconfig include in Flutter-Release.xcconfig fails.
set -ex

git clone https://github.com/flutter/flutter.git -b 3.41.7 --depth 1 "$HOME/flutter"
export PATH="$PATH:$HOME/flutter/bin"

flutter --version
flutter precache --macos

cd "$CI_PRIMARY_REPOSITORY_PATH"
flutter pub get

cd macos
pod install
