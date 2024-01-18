#!/bin/zsh

# --------------------------------------------------------------
# File: bf_completions.zsh
# Description: This script sets up various options and styles that affect how Zsh
# handles command-line completion. This is meant to optimise the user's interaction
# with the completion system.
# 
# Credits: https://github.com/mattmc3/zephyr/blob/main/plugins/completion/functions/run-compinit
# --------------------------------------------------------------

# If a completion is performed with the cursor within a word, and a full
# completion is inserted, the cursor is moved to the end of the word.
setopt always_to_end

# If unset, the cursor is set to the end of the word if completion is started.
# Otherwise it stays there and completion is done from both ends.
setopt complete_in_word

setopt auto_menu            # Show completion menu on a successive tab press.
setopt auto_list            # Automatically list choices on ambiguous completion.
setopt auto_param_slash     # If completed parameter is a directory, add a trailing slash.
setopt extended_glob        # Needed for file modification glob modifiers with compinit.
setopt NO_menu_complete     # Do not autoselect the first completion entry.
setopt NO_flow_control      # Disable start/stop characters in shell editor.

# Don't beep on an ambiguous completion.
unsetopt list_beep

# Adjust WORDCHARS to treat certain characters as part of words.
# See 4.3.4 of http://zsh.sourceforge.net/Guide/zshguide04.html.
WORDCHARS=${WORDCHARS/\/}

# Since we are using menu-select, we need to load complist before calling compinit.
# See https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Use-of-compinit
zmodload zsh/complist

emulate -L zsh
setopt localoptions extendedglob

local force=0
if [[ "$1" == "-f" ]]; then
  force=1
  shift
fi

local zcompdump=${1:-${ZSH_COMPDUMP:-${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump}}
[[ -d "$zcompdump:h" ]] || mkdir -p "$zcompdump:h"
autoload -Uz compinit

# Completion ref: https://thevaluable.dev/zsh-completion-guide-examples/; Init completion

# if compdump is less than 20 hours old,
# consider it fresh and shortcut it with `compinit -C`
#
# Glob magic explained:
#   #q expands globs in conditional expressions
#   N - sets null_glob option (no error on 0 results)
#   mh-20 - modified less than 20 hours ago
if [[ $force -ne 1 ]] && [[ $zcompdump(#qNmh-20) ]]; then
  # -C (skip function check) implies -i (skip security check).
  compinit -C -d "$zcompdump"
else
  compinit -i -d "$zcompdump"
  touch "$zcompdump"
fi

# Compile zcompdump, if modified, in background to increase startup speed.
{
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    if command mkdir "${zcompdump}.zwc.lock" 2>/dev/null; then
      zcompile "$zcompdump"
      command rmdir  "${zcompdump}.zwc.lock" 2>/dev/null
    fi
  fi
} &!

# Menu selection will be started unconditionally.
zstyle ':completion:*' menu select=4

# Try smart-case completion, then case-insensitive, then partial-word, and then
# substring completion.
# See http://zsh.sourceforge.net/Doc/Release/Completion-Widgets.html#Completion-Matching-Control.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Z}{a-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' completer _expand _complete _ignored _approximate
# zstyle ':completion:*' max-errors 3 numeric
zstyle ':completion:*' group-name ''

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending
