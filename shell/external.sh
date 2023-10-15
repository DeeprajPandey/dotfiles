# shellcheck shell=bash
# To allow shellcheck linting

# Change default strahip prompt config file location
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true

# Cache pip-installed packages to avoid re-downloading
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache

# Docker
export DOCKER_SCAN_SUGGEST=false
