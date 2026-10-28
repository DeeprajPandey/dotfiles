# shellcheck shell=bash
# To allow shellcheck linting

path_remove() {
  local p=":$PATH:"
  p=${p//":$1:"/:}
  p=${p#:}
  PATH=${p%:}
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

# Homebrew's python@3.10/3.13/3.14 bottles link pyexpat against the system
# libexpat, which is missing a symbol on macOS 26.0-26.2. Re-patch after any
# brew command that could reinstall python. See fix-pyexpat in ~/.local/bin.
brew() {
    command brew "$@"
    local brew_status=$?
    case "${1:-}" in
        install|upgrade|reinstall|autoremove)
            command -v fix-pyexpat >/dev/null 2>&1 && fix-pyexpat
            ;;
    esac
    return $brew_status
}
