# shellcheck shell=bash
# To allow shellcheck linting

export PATH="/usr/local/sbin:$PATH"

# Reduces delay when entering vi-mode
export KEYTIMEOUT=1

# References:
#   https://stackoverflow.com/a/43087047
#   https://github.com/zsh-users/zsh/blob/96a79938010073d14bd9db31924f7646968d2f4a/Src/Zle/zle_keymap.c#L1437-L1439
#   https://github.com/yous/dotfiles/commit/c29bf215f5a8edc6123819944e1bf3336a4a6648
# if (( $+commands[vim] )); then
#   export EDITOR=vim
#   bindkey -e
# fi

## Go and Protobuf
# export GOROOT=/usr/local/go
# export GOPATH=$HOME/go
# export GOBIN=$GOPATH/bin
# export PATH=$PATH:$GOROOT:$GOPATH:$GOBIN

# Temp bin - primarily used for tmpmail
export PATH="$PATH:~/.dotfiles/tmpbin"

# Make the $path array have unique values.
typeset -U PATH