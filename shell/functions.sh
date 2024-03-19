# shellcheck shell=bash
# To allow shellcheck linting

path_remove() {
    PATH=$(echo -n "$PATH" | awk -v RS=: -v ORS=: "\$0 != \"$1\"" | sed 's/:$//')
}

path_append() {
    path_remove "$1"
    PATH="${PATH:+"$PATH:"}$1"
}

path_prepend() {
    path_remove "$1"
    PATH="$1${PATH:+":$PATH"}"
}

# Basic here-there based sigle-dir bookmarking system
here() {
    local loc
    if [ "$#" -eq 1 ]; then
        loc=$(realpath "$1")
    else
        loc=$(realpath ".")
    fi
    ln -sfn "${loc}" "$HOME/.shell.here"
    echo "here -> $(readlink "$HOME"/.shell.here)"
}

there="$HOME/.shell.here"

there() {
    cd "$(readlink "${there}")" || exit
}

colour-test() {
  for i in {0..256} ; do
    printf "\x1b[38;5;${i}m${i}  "
  done
}
