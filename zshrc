# https://github.com/Homebrew/homebrew-core/issues/14737#issuecomment-309848851
GPG_TTY="$(tty)" && export GPG_TTY

# Init the shell prompt
eval "$(starship init zsh)"