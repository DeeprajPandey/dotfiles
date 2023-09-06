# Init the shell prompt
eval "$(starship init zsh)"

# Set up gpg agent
# https://github.com/Homebrew/homebrew-core/issues/14737#issuecomment-309848851
export GPG_TTY="$(tty)"
gpg-connect-agent updatestartuptty /bye >/dev/null