# shellcheck shell=bash
# To allow shellcheck linting

# Update dotfiles
dfu() {
  (
    cd ~/dotfiles && git pull --ff-only && ./install -q
  )
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

# Argbash via docker container
# https://web.archive.org/web/20230927191830/https://github.com/matejak/argbash/blob/master/docker/README.md
function argbash() {
  docker run --rm \
  -v "$(pwd):/work" \
  -u "$(id -u):$(id -g)" matejak/argbash "$@"
}

function argbash-init() {
  docker run --rm -e PROGRAM=argbash-init \
  -v "$(pwd):/work" \
  -u "$(id -u):$(id -g)" matejak/argbash "$@"
}