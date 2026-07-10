#!/bin/bash

# build.sh - Complete build script

echo "🚀 Starting Flutter Build"
echo "========================"

# Clean
echo "🧹 Cleaning..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Format
echo "🎨 Formatting code..."
dart format lib/ test/

# Analyze
echo "🔍 Analyzing code..."
flutter analyze

# Run tests
echo "🧪 Running tests..."
flutter test --coverage

# Build APK
echo "🚀 Building APK..."
flutter build apk --release --split-per-abi

# Build App Bundle
echo "🚀 Building App Bundle..."
flutter build appbundle --release

echo ""
echo "✅ Build complete!"
echo "📁 APK: build/app/outputs/flutter-apk/"
echo "📁 AAB: build/app/outputs/bundle/release/"
echo "📁 Coverage: coverage/html/index.html"