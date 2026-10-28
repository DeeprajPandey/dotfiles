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

# Create pipenv virtualenvs in project directory to avoid pipenv install on project path restructures
# https://pipenv.pypa.io/en/latest/installation.html#virtualenv-mapping-caveat
export PIPENV_VENV_IN_PROJECT=1

# Enable IDF virtual environment when needed
alias get_idf='. $HOME/esp/esp-idf/export.sh'

# Setup fzf shell integration
# shellcheck source=/opt/homebrew/bin/fzf
source <(fzf --zsh)

path_prepend "$HOME/bin"
eval "$(~/.local/bin/mise activate zsh)"

# enable xelatex on terminal (from brew fomula `basictex`)
# NOTE: path_helper messed up path order
# eval $(/usr/libexec/path_helper)
path_append "/Library/TeX/texbin"
