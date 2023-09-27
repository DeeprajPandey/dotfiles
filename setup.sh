#!/usr/bin/env bash

# Define color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

function log_info() {
    echo -e "${YELLOW}[INFO] $1${NC}"
}

function log_success() {
    echo -e "${GREEN}[SUCCESS] $1${NC}"
}

# Installs foundational components: xcode-select, Homebrew, and Docker.
# Ensures Docker is running and initialises a project directory.
function install_core_dependencies() {
    log_info "Setting up your Mac's core dependencies..."

    # See: determining whether a command exists
    # https://unix.stackexchange.com/questions/85249/why-not-use-which-what-to-use-then

    # Install Xcode Command Line Tools
    if ! type -a xcode-select > /dev/null 2>&1; then
        log_info "Installing Xcode Command Line Tools..."
        xcode-select --install &>/dev/null

        # Wait until the Xcode Command Line Tools are installed
        until xcode-select -p &>/dev/null; do
            sleep 5
        done
        log_success "Xcode Command Line Tools installed."
    fi

    # Install Homebrew if it's missing
    if ! type -a brew > /dev/null 2>&1; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
        log_success "Homebrew installed."
    fi

    # Update Homebrew and upgrade formulae
    log_info "Updating Homebrew and upgrading installed formulae..."
    brew update && brew upgrade

    # Install docker and start the daemon before moving to Brewfile (whalebrew needs this)
    log_info "Installing and starting Docker..."
    brew install --cask docker

    # Run Docker if it's not running
    if ! type -a docker > /dev/null 2>&1; then
        open /Applications/Docker.app
        
        # Wait until Docker daemon is running and has completed initialisation
        until docker stats --no-stream &> /dev/null; do
            echo -e "\\n${YELLOW}[INFO] Waiting for Docker to launch...${NC}"
            sleep 5
        done
        log_success "Docker is running."
    fi

    # Create a projects dir and symlink to ~
    log_info "Creating a working directory and linking to home..."
    mkdir -p "$HOME"/Documents/wd
    ln -sfn "$HOME"/Documents/wd ~/wd
    log_success "Working directory initialised and linked."
}

# Installs Brew formulae and casks from Brewfile and sets up the shell using Dotbot.
function setup_environment_and_shell() {
    echo -e "\\n${YELLOW}[INFO] Setting up your environment and shell...${NC}"

    # Install all our dependencies with bundle (See Brewfile)
    # https://github.com/Homebrew/homebrew-bundle
    log_info "Installing dependencies from Brewfile..."
    brew tap homebrew/bundle
    brew bundle --file ./init/Brewfile
    log_success "Homebrew formulae and casks installed."

    # Set up the shell and everything else
    log_info "Setting up the shell using dotbot..."
    # shellcheck source=/dev/null
    source ./install
    log_success "Shell set up."
}

# Applies user-preferred configurations and settings to MacOS.
function apply_macos_configurations() {
    # Set macOS preferences - we will run this last because this will reload the shell
    echo -e "\\n${YELLOW}[INFO] Applying MacOS configurations...${NC}"
    # shellcheck source=/dev/null
    source ./init/macos.sh
    log_success "MacOS configurations applied."
}
