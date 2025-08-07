#!/bin/bash

echo "🧹 Starting iOS cleanup process..."

# Navigate to the iOS folder
cd "$(dirname "$0")"

# Remove Podfile.lock to force dependency resolution
echo "🗑️  Removing Podfile.lock..."
rm -f Podfile.lock

# Clean CocoaPods cache
echo "🗑️  Cleaning CocoaPods cache..."
rm -rf ~/.cocoapods/repos/trunk/Specs

# Remove build artifacts
echo "🗑️  Removing build artifacts..."
rm -rf ./build
rm -rf ./Pods
rm -rf ./.symlinks
rm -rf ./Flutter/Flutter.podspec
rm -rf ./Flutter/ephemeral

# Remove flutter generated files
echo "🗑️  Removing Flutter generated files..."
cd ..
flutter clean

# Get packages
echo "📦 Getting Flutter packages..."
flutter pub get

# Return to iOS directory
cd ios

# Install pods with repo update
echo "📱 Running pod install with repo update..."
pod install --repo-update

echo "✅ iOS cleanup complete!"
echo ""
echo "If you're still experiencing issues, please try:"
echo "1. Open Xcode with 'open Runner.xcworkspace'"
echo "2. In Xcode, go to File > Workspace Settings"
echo "3. Set 'Build System' to 'New Build System'"
echo "4. Close and reopen Xcode"
echo "5. Run the app from Flutter again"
