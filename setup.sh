#!/usr/bin/env bash

# Define color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Installs foundational components: xcode-select, Homebrew, and Docker.
# Ensures Docker is running and initialises a project directory.
function install_core_dependencies() {
    echo -e "${YELLOW}[INFO] Setting up your Mac's core dependencies...${NC}"

    # See: determining whether a command exists
    # https://unix.stackexchange.com/questions/85249/why-not-use-which-what-to-use-then

    # Install Xcode Command Line Tools
    if ! type -a xcode-select > /dev/null 2>&1; then
        echo -e "${YELLOW}[INFO] Installing Xcode Command Line Tools...${NC}"
        xcode-select --install &>/dev/null

        # Wait until the Xcode Command Line Tools are installed
        until xcode-select -p &>/dev/null; do
            sleep 5
        done
        echo -e "${GREEN}[SUCCESS] Xcode Command Line Tools installed.${NC}"
    fi

    # Install Homebrew if it's missing
    if ! type -a brew > /dev/null 2>&1; then
        echo -e "${YELLOW}[INFO] Installing Homebrew...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo -e "${GREEN}[SUCCESS] Homebrew installed.${NC}"
    fi

    # Update Homebrew recipes
    echo -e "${YELLOW}[INFO] Updating Homebrew recipes and upgrading installed formulae...${NC}"
    brew update && brew upgrade

    # Install docker and start the daemon before moving to Brewfile (whalebrew needs this)
    echo -e "${YELLOW}[INFO] Installing and starting Docker...${NC}"
    brew install --cask docker

    # Run Docker if it's not running
    if ! type -a docker > /dev/null 2>&1; then
        open /Applications/Docker.app
        
        # Wait until Docker daemon is running and has completed initialisation
        until docker stats --no-stream &> /dev/null; do
            echo -e "\\n${YELLOW}[INFO] Waiting for Docker to launch...${NC}"
            sleep 5
        done
        echo -e "${GREEN}[SUCCESS] Docker is running.${NC}"
    fi

    # Create a projects dir and symlink to ~
    echo -e "${YELLOW}[INFO] Creating a working directory and linking to home...${NC}"
    mkdir -p "$HOME"/Documents/wd
    ln -sfn "$HOME"/Documents/wd ~/wd
    echo -e "${GREEN}[SUCCESS] Working directory initialised and linked.${NC}"
}

# Installs Brew formulae and casks from Brewfile and sets up the shell using Dotbot.
function setup_environment_and_shell() {
    echo -e "\\n${YELLOW}[INFO] Setting up your environment and shell...${NC}"

    # Install all our dependencies with bundle (See Brewfile)
    # https://github.com/Homebrew/homebrew-bundle
    echo -e "${YELLOW}[INFO] Installing dependencies from Brewfile...${NC}"
    brew tap homebrew/bundle
    brew bundle --file ./init/Brewfile
    echo -e "${GREEN}[SUCCESS] Homebrew formulae and casks installed.${NC}"

    # Set up the shell and everything else
    echo -e "${YELLOW}[INFO] Setting up the shell using dotbot...${NC}"
    # shellcheck source=/dev/null
    source ./install
    echo -e "${GREEN}[SUCCESS] Shell set up.${NC}"
}

# Applies user-preferred configurations and settings to MacOS.
function apply_macos_configurations() {
    # Set macOS preferences - we will run this last because this will reload the shell
    echo -e "\\n${YELLOW}[INFO] Applying MacOS configurations...${NC}"
    # shellcheck source=/dev/null
    source ./init/macos.sh
    echo -e "${GREEN}[SUCCESS] MacOS configurations applied.${NC}"
}
