# shellcheck shell=bash
# To allow shellcheck linting

# Single character alias
alias _='sudo'
alias g='git'
alias l='ls'

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

# Better defaults
alias vi='vim'
alias nv='nvim'
alias  ping='ping -c 5'

# fix typos
alias got=git
alias quit='exit'
alias cd..='cd ..'
alias zz='exit'

# tar
alias tarls="tar -tvf"
alias untar="tar -xvf"
alias untars="tar -xvzf"

# cd to git root directory
alias cdgr='cd "$(git root)"'

# good 'ol cls
alias cls='clear'

# date/time
alias timestamp="date '+%Y-%m-%d %H:%M:%S'"
alias datestamp="date '+%Y-%m-%d'"
alias isodate="date +%Y-%m-%dT%H:%M:%S%z"
alias utc="date -u +%Y-%m-%dT%H:%M:%SZ"
alias unixepoch="date +%s"

# find
alias fd='find . -type d -name'
alias ff='find . -type f -name'

# fast reload zshrc
alias reload='source ~/.zshrc'

# disk usage
biggest() {
  du -s ./* | sort -nr | awk "{print $2}" | xargs du -sh
}
alias dux='du -x --max-depth=1 | sort -n'
alias dud='du -d 1 -h'
alias duf='du -sh *'

# print things
alias print-path='echo $PATH | tr ":" "\n"'
alias print-functions='print -l ${(k)functions[(I)[^_]*]} | sort'

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
  local port=${1:-8000}
  local dir=${2:-.}
  local pidfile
  local fswatch_pid
  
  # Create temp file to pass PID to and from fswatch subshell
  pidfile=$(mktemp -t serve_"$port".pid)

  # Function to start the server
  start_server() {
    pushd "$dir" > /dev/null || exit
    python3 -m http.server "$port" &
    echo $! > "$pidfile"
    popd > /dev/null || exit
  }

  # Function to stop the server
  stop_server() {
    if [ -f "$pidfile" ]; then
      local server_pid
      server_pid=$(cat "$pidfile")

      if [ -n "$server_pid" ]; then
        echo "Stopping server[$server_pid]..."
        kill "$server_pid"
        wait "$server_pid" 2>/dev/null
      fi

    fi
  }

  # Start the server initially
  start_server

  # Watch for changes in the directory
  # Start fswatch and while loop in their own process group
  set -m                  # enable job control
  (
  fswatch -o "$dir" | while read -r num_changes; do
    echo "File changed. Restarting server..."
    stop_server
    echo "Current server_pid (should be empty): $(cat "$pidfile")"
    start_server
    echo "Current server_pid (should be new): $(cat "$pidfile")"
  done
  ) &

  # Save PID of fswatch loop
  fswatch_pid=$!
  echo "fswatch_pid: $fswatch_pid"

  # shellcheck disable=SC2317
  # Handle script exit (gets invoked by trap)
  cleanup() {
    stop_server
    kill -- -$$           # kill process group
    rm -f "$pidfile"      # remove temp file
    exit 0
  }
  
  # Trap SIGINT (Ctrl+C) and SIGTERM
  trap cleanup SIGINT SIGTERM

  # Wait indefinitely
  wait
}


# Mirror a website
alias mirrorsite='wget -m -k -K -E -e robots=off'

# Mirror stdout to stderr, useful for seeing data going through a pipe
alias peek='tee >(cat 1>&2)'
