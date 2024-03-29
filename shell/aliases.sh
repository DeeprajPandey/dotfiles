# shellcheck shell=bash
# To allow shellcheck linting

# Use colors in coreutils utilities output
alias grep='grep --color'

# ls aliases - make sure exa is installed
alias ls='exa --group-directories-first --icons -aG'
alias le='exa --icons -aG'
alias ld='exa --icons --time-style=default -s=Filename -FlaghHD'
alias la='exa --group-directories-first --colour-scale --icons --time-style=default -s=Filename -FlaghHS'
alias LD='exa --icons --time-style=default -s=Filename -laghHiD'
alias LA='exa --group-directories-first --colour-scale --icons --time-style=default -s=Filename -laghHiS'
# Tree commands which need a level number, e.g. `lt 2`
alias lt='exa --tree --icons --group-directories-first -L'
alias ltd='exa --tree --icons -aDL'

# Aliases to protect against overwriting
alias cp='cp -i'
alias mv='mv -i'

# Git alias
alias g='git'

# cd to git root directory
alias cdgr='cd "$(git root)"'

# good 'ol cls
alias cls='clear'

# make sure docker is installed, gcloud image exists, and you have authenticated
# using a mounted volume to $HOME/.config/gcloud before using this
alias gcloud='docker run --rm -ti \
-v $HOME/.config/gcloud:/root/.config/gcloud \
gcr.io/google.com/cloudsdktool/google-cloud-cli gcloud'

