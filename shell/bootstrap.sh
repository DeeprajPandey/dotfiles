# shellcheck shell=bash
# To allow shellcheck linting

path_prepend "/usr/local/sbin"
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.dotfiles/bin"

# Reduces delay when entering vi-mode
export KEYTIMEOUT=1

# Only keep unique values in $PATH array
typeset -U PATH
