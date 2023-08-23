#!/bin/bash

echo "Setting up your Mac..."

# Install Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
    xcode-select --install &>/dev/null

    # Wait until the Xcode Command Line Tools are installed
    until xcode-select -p &>/dev/null; do
        sleep 5
    done
fi

# Install Homebrew if it's missing
if test ! $(which brew); then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
# https://github.com/Homebrew/homebrew-bundle
brew tap homebrew/bundle
brew bundle --file ./Brewfile

# Create a projects dir
mkdir $HOME/Documents/wd
