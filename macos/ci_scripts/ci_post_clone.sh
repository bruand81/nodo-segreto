#!/bin/sh
# Xcode Cloud only clones the git repo — Flutter is not preinstalled and
# macos/Flutter/ephemeral/ (gitignored) is never generated. Without it,
# the xcconfig include in Flutter-Release.xcconfig fails.
set -ex

# CI networking to storage.googleapis.com occasionally resets mid-download;
# retry the network-heavy steps instead of failing on one blip.
retry() {
  n=1
  until "$@"; do
    n=$((n + 1))
    if [ "$n" -gt 3 ]; then
      return 1
    fi
    echo "Retrying ($n/3): $*"
    sleep 5
  done
}

rm -rf "$HOME/flutter"
retry git clone https://github.com/flutter/flutter.git -b 3.44.8 --depth 1 "$HOME/flutter"
export PATH="$PATH:$HOME/flutter/bin"

flutter --version
retry flutter precache --macos

cd "$CI_PRIMARY_REPOSITORY_PATH"
retry flutter pub get

# pub get alone doesn't populate macos/Flutter/ephemeral/*.xcfilelist —
# those are only written by "flutter assemble", which the Xcode archive
# step's "Flutter Assemble" run-script phase needs to already exist before
# it runs. --config-only generates them without doing a redundant full build.
# This is also where Xcode resolves the Swift Package Manager plugin
# dependencies (FlutterGeneratedPluginSwiftPackage), so it's still wrapped
# in retry() for network resilience.
retry flutter build macos --release --config-only
