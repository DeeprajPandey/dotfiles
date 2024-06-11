#!/usr/bin/env bash
# ARG_OPTIONAL_BOOLEAN([install], [i], [Perform a fresh installation. This is the default behavior.], [on])
# ARG_OPTIONAL_BOOLEAN([update], [u], [Update the installed tools and applications.])
# ARG_OPTIONAL_BOOLEAN([configure-os], [c], [Reconfigure the operating system settings.])
# ARG_HELP([This script automates the setup of a MacOS environment. It can perform a fresh installation, update tools and applications, or reconfigure the operating system settings. By default, it performs a fresh installation unless another option is provided.])
# ARGBASH_GO

# [ <-- needed because of Argbash

declare _arg_install
declare _arg_update
declare _arg_configure_os

# Assign CLI args to variables for brevity
flag_install=$_arg_install
flag_update=$_arg_update
flag_config=$_arg_configure_os

# Get the directory of the currently executing script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Define color codes
# Argbash workaround for square brackets:
# https://web.archive.org/web/20230927170347/https://argbash.readthedocs.io/en/latest/#limitations
GREEN='\033[0;32m'          # match square bracket for argbash: ]
YELLOW='\033[1;33m'         # match square bracket for argbash: ]
NC='\033[0m' # No Color     # match square bracket for argbash: ]

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
    log_info "Creating a working directory, gnupg, and spicetify dirs to symlink everything appropriately..."
    mkdir -p "$HOME"/Documents/wd
    ln -sfn "$HOME"/Documents/wd "$HOME"/wd
    mkdir -p "$HOME/.gnupg"
    mkdir -p "$HOME/.config/spicetify"
    log_success "Directories initialised and linked."

    log_info "Install rustup and rust. Ref: https://www.rust-lang.org/learn/get-started"
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
    source "$DIR/install"

    # Initialise launchd services
    # SKetchybar: get community font ligatures
    # curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v1.0.23/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf
    # brew services restart sketchybar
    yabai --restart-service
    skhd --restart-services
    log_success "Shell set up."
}

# Applies user-preferred configurations and settings to MacOS.
function apply_macos_configurations() {
    # Set macOS preferences - we will run this last because this will reload the shell
    echo -e "\\n${YELLOW}[INFO] Applying MacOS configurations...${NC}"

    # InternetServices (setting timezone), destroy fv key on standby outputs can be safely ignored
    # https://github.com/LnL7/nix-darwin/issues/359#issuecomment-1721755685
    # shellcheck source=/dev/null
    source "$DIR/init/macos.sh"
    log_success "MacOS configurations applied."
}

# Check the provided options and perform the corresponding actions
if [ "$flag_update" = on ]; then
    setup_environment_and_shell
elif [ "$flag_config" = on ]; then
    apply_macos_configurations
elif [ "$flag_install" = on ]; then
    install_core_dependencies
    setup_environment_and_shell
    apply_macos_configurations
else
    # Same behaviour as `$flag_install` now; can be extended later
    install_core_dependencies
    setup_environment_and_shell
    apply_macos_configurations
fi

# ] <-- needed because of Argbash
