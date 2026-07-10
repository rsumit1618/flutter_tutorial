#!/bin/bash

# ============================================
# update_version.sh - Update version in pubspec.yaml
# Usage: ./scripts/update_version.sh [major|minor|patch]
# ============================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if argument is provided
if [ $# -eq 0 ]; then
    echo -e "${RED}❌ Error: Version type required${NC}"
    echo "Usage: ./scripts/update_version.sh [major|minor|patch]"
    echo ""
    echo "Examples:"
    echo "  ./scripts/update_version.sh patch   # 1.0.0+1 → 1.0.1+2"
    echo "  ./scripts/update_version.sh minor   # 1.0.1+2 → 1.1.0+3"
    echo "  ./scripts/update_version.sh major   # 1.1.0+3 → 2.0.0+4"
    exit 1
fi

# Check if pubspec.yaml exists
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ Error: pubspec.yaml not found in current directory${NC}"
    echo "Please run this script from the project root."
    exit 1
fi

# Get current version from pubspec.yaml
CURRENT_VERSION=$(grep 'version:' pubspec.yaml | awk '{print $2}')
echo -e "${YELLOW}📦 Current version: ${CURRENT_VERSION}${NC}"

# Parse version components
MAJOR=$(echo $CURRENT_VERSION | cut -d. -f1)
MINOR=$(echo $CURRENT_VERSION | cut -d. -f2)
PATCH=$(echo $CURRENT_VERSION | cut -d. -f3 | cut -d+ -f1)
BUILD=$(echo $CURRENT_VERSION | cut -d+ -f2)

# If BUILD is empty, set to 0
if [ -z "$BUILD" ]; then
    BUILD=0
fi

# Update version based on argument
case $1 in
    major)
        MAJOR=$((MAJOR + 1))
        MINOR=0
        PATCH=0
        echo -e "${YELLOW}📈 Bumping MAJOR version${NC}"
        ;;
    minor)
        MINOR=$((MINOR + 1))
        PATCH=0
        echo -e "${YELLOW}📈 Bumping MINOR version${NC}"
        ;;
    patch)
        PATCH=$((PATCH + 1))
        echo -e "${YELLOW}📈 Bumping PATCH version${NC}"
        ;;
    *)
        echo -e "${RED}❌ Invalid option: $1${NC}"
        echo "Use: major, minor, or patch"
        exit 1
        ;;
esac

# Increment build number
BUILD=$((BUILD + 1))

# Create new version
NEW_VERSION="$MAJOR.$MINOR.$PATCH+$BUILD"

# Update pubspec.yaml
sed -i "s/version: .*/version: $NEW_VERSION/" pubspec.yaml

# Show success message
echo -e "${GREEN}✅ Version updated: ${CURRENT_VERSION} → ${NEW_VERSION}${NC}"

# Show git status
echo ""
echo -e "${YELLOW}📋 Git status:${NC}"
git status --short

echo ""
echo -e "${YELLOW}💡 Next steps:${NC}"
echo "1. Review changes: git diff pubspec.yaml"
echo "2. Stage changes: git add pubspec.yaml"
echo "3. Commit changes: git commit -m \"chore: bump version to $NEW_VERSION\""
echo "4. Push changes: git push"