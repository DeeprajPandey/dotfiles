#!/usr/bin/env bash

echo -e "\\nSetting up your Mac..."

# See: determining whether a command exists
# https://unix.stackexchange.com/questions/85249/why-not-use-which-what-to-use-then

# Install Xcode Command Line Tools
if ! type -a xcode-select > /dev/null 2>&1; then
    xcode-select --install &>/dev/null

    # Wait until the Xcode Command Line Tools are installed
    until xcode-select -p &>/dev/null; do
        sleep 5
    done
fi

# Install Homebrew if it's missing
if ! type -a brew > /dev/null 2>&1; then
    echo -e "\\nInstalling Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Update Homebrew recipes
brew update && brew upgrade

# Install docker and start the daemon before moving to Brewfile (whalebrew needs this)
brew install --cask docker

# Run Docker if it's not running
if ! type -a docker > /dev/null 2>&1; then
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

# Create a projects dir and symlink to ~
mkdir -p "$HOME"/Documents/wd
ln -sfn "$HOME"/Documents/wd ~/wd

# Set macOS preferences - we will run this last because this will reload the shell
# shellcheck source=/dev/null
source ./init/macos.sh
