# shellcheck shell=bash
# To allow shellcheck linting

path_prepend "/usr/local/sbin"
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.dotfiles/bin"
path_append "$HOME/.luarocks/bin"

# symlinks for compilers which will use ccache automatically
path_prepend "/opt/homebrew/opt/ccache/libexec"

# for rustup: need cargo's bin dir in path (prepended based on comments in `~/.cargo/env`)
# prepend: in case a system-installed rustc needs to be overridden
path_prepend "$HOME/.cargo/bin"

# Reduces delay when entering vi-mode
export KEYTIMEOUT=1

# Only keep unique values in $PATH array
typeset -U PATH
