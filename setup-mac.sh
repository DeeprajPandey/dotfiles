#!/bin/bash

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

# Install essential tools
brew install wget
brew install git
brew install gpg

# Install essential casks (GUI applications)
brew install --cask iterm2
brew install --cask firefox
brew install --cask visual-studio-code
brew install --cask docker
brew install --cask keepassxc
brew install --cask protonvpn
brew install --cask aldente
brew install --cask monitorcontrol
brew install --cask google-drive
# brew install --cask logi-options-plus     # iff 3S is on the desk

# Install font cask for nerd-fonts and such
# Font preview: https://www.programmingfonts.org/#source-code-pro
brew tap homebrew/cask-fonts
brew install font-source-code-pro-for-powerline
# brew install font-fira-code-nerd-font
# brew install font-hack-nerd-font

# Cleanup brew
brew cleanup