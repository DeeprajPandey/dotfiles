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

# Update dotfiles
dfu() {
  (
    cd ~/dotfiles && git pull --ff-only && ./install -q
  )
}

# Use pip without requiring virtualenv
syspip() {
    PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

syspip2() {
    PIP_REQUIRE_VIRTUALENV="" pip2 "$@"
}

syspip3() {
    PIP_REQUIRE_VIRTUALENV="" pip3 "$@"
}

# Create a directory and cd into it
mcd() {
  mkdir "${1}" && cd "${1}" || return
}

# Go up [n] directories
up() {
  cdir="$(pwd)"
  local cdir
  if [[ "${1}" == "" ]]; then
    cdir="$(dirname "${cdir}")"
  elif ! [[ "${1}" =~ ^[0-9]+$ ]]; then
    echo "Error: argument must be a number"
  elif ! [[ "${1}" -gt "0" ]]; then
    echo "Error: argument must be positive"
  else
    for ((i = 0; i < ${1}; i++)); do
      ncdir="$(dirname "${cdir}")"
      local ncdir
      if [[ "${cdir}" == "${ncdir}" ]]; then
        break
      else
        cdir="${ncdir}"
      fi
    done
  fi
  cd "${cdir}" || return
}

# Check if a file contains non-ascii characters
nonascii() {
  LC_ALL=C grep -n '[^[:print:][:space:]]' "${1}"
}

# Fetch pull request
fpr() {
  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "error: fpr must be executed from within a git repository"
    return 1
  fi
  (
    cdgr
    if [ "$#" -eq 1 ]; then
      local repo="${PWD##*/}"
      local user="${1%%:*}"
      local branch="${1#*:}"
    elif [ "$#" -eq 2 ]; then
      local repo="${PWD##*/}"
      local user="${1}"
      local branch="${2}"
    elif [ "$#" -eq 3 ]; then
      local repo="${1}"
      local user="${2}"
      local branch="${3}"
    else
      echo "Usage: fpr [repo] username branch"
      return 1
    fi

    git fetch "git@github.com:${user}/${repo}" "${branch}:${user}/${branch}"
  )
}

# Serve current directory
serve() {
  python3 -m http.server
}

# Mirror a website
alias mirrorsite='wget -m -k -K -E -e robots=off'

# Mirror stdout to stderr, useful for seeing data going through a pipe
alias peek='tee >(cat 1>&2)'

## Run executable from local node_modules/
# https://web.archive.org/web/20200812154305/https://2ality.com/2016/01/locally-installed-npm-executables.html
function npm-do { (PATH=$(npm bin):$PATH; "$@";) }
