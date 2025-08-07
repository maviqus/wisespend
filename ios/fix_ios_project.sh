#!/bin/bash

# Navigate to the iOS folder
cd "$(dirname "$0")"

# Create backup of current project files
echo "Creating backup of current project files..."
mkdir -p backup
cp -R Runner.xcodeproj backup/Runner.xcodeproj_backup_$(date +%Y%m%d%H%M%S)

# Clean the build folders
echo "Cleaning build folders..."
rm -rf build
rm -rf Pods
rm -rf .symlinks
rm -rf .flutter-plugins-dependencies
rm -rf Flutter/Flutter.podspec
rm -rf Flutter/ephemeral

# Return to the Flutter project root
cd ..

# Run Flutter clean
echo "Running flutter clean..."
flutter clean

# Get dependencies
echo "Getting dependencies..."
flutter pub get

# Rebuild iOS
echo "Rebuilding iOS files..."
flutter build ios --no-codesign

echo "iOS project files have been fixed. Try running your app again."
