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

# export NVM_DIR="$HOME/.nvm"
# [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
# [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion



# Create pipenv virtualenvs in project directory to avoid pipenv install on project path restructures
# https://pipenv.pypa.io/en/latest/installation.html#virtualenv-mapping-caveat
export PIPENV_VENV_IN_PROJECT=1

# Enable IDF virtual environment when needed
alias get_idf='. $HOME/esp/esp-idf/export.sh'

# Setup fzf shell integration
# shellcheck source=/opt/homebrew/bin/fzf
source <(fzf --zsh)

# Setup golang paths
export GOPATH="${HOME}/go"
export GOROOT="$(brew --prefix golang)/libexec"
path_append "${GOPATH}/bin:${GOROOT}/bin"

# Setup rebar3 paths
path_append "${HOME}/.cache/rebar3/bin"

# pnpm
export PNPM_HOME="/opt/homebrew/bin/pnpm"
path_append "$PNPM_HOME"

export POSTGRESQL_BIN="/opt/homebrew/opt/postgresql@15/bin"
path_prepend "$POSTGRESQL_BIN"
export LDFLAGS="-L/opt/homebrew/opt/postgresql@15/lib"
export CPPFLAGS="-I/opt/homebrew/opt/postgresql@15/include"
export LIBRARY_PATH=$LIBRARY_PATH:/opt/homebrew/opt/openssl/lib

# Added by Windsurf
path_prepend "/Users/vieuler/.codeium/windsurf/bin"

