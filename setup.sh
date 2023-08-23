#!/usr/bin/env bash

echo -e "\\nSetting up your Mac..."

# Install Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
    xcode-select --install &>/dev/null

    # Wait until the Xcode Command Line Tools are installed
    until xcode-select -p &>/dev/null; do
        sleep 5
    done
fi

# Install Homebrew if it's missing
if test ! "$(which brew)"; then
    echo -e "\\nInstalling Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Update Homebrew recipes
brew update && brew upgrade

# Install docker and start the daemon before moving to Brewfile (whalebrew needs this)
brew install --cask docker

# Run Docker if it's not running
if (! docker stats --no-stream &> /dev/null ); then
    open /Applications/Docker.app
    
    # Wait until Docker daemon is running and has completed initialisation
    until docker stats --no-stream &> /dev/null; do
        echo -e "\\nWaiting for Docker to launch..."
        sleep 5
    done
fi

# Install all our dependencies with bundle (See Brewfile)
# https://github.com/Homebrew/homebrew-bundle
brew tap homebrew/bundle
brew bundle --file ./init/Brewfile

# Create a projects dir
mkdir "$HOME"/Documents/wd
