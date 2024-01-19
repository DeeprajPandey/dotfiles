# ZSH Options ref: http://zsh.sourceforge.net/Doc/Release/Options.html.
# From https://github.com/yous/vanilli.sh/blob/master/vanilli.zsh

# Ensure the variable '0' holds the absolute path of the running script.
# This approach helps in situations where '0' might be unset or null.
0=${(%):-%N}

# Expand 'fpath' to include our custom 'plugins' directory.
# The '0:h' modifier is used to get the directory of the current script, respecting
# the structure within '$HOME/.config/zsh'. It helps maintain a clean and consistent
# environment, especially when dealing with symlinked directories.
fpath=(${0:h}/plugins $fpath)

# =============================================================================
# Changing Directories
# =============================================================================

# If a command is issued that can't be executed as a normal command, and the
# command is the name of a directory, perform the cd command to that directory.
setopt auto_cd

# Make cd push the old directory onto the directory stack.
setopt auto_pushd

# Don't push multiple copies of the same directory onto the directory stack.
setopt pushd_ignore_dups

# Allow for corrections when mistyping directory names with 'cd'.
# Zsh will suggest the closest match.
setopt correct_all

# The prompt will display information about the status of a background job 
# if it starts or stops. Useful if you background tasks often.
setopt notify

# =============================================================================
# Completion
# =============================================================================
# Ref: https://thevaluable.dev/zsh-completion-guide-examples/

# Since we are using menu-select, we need to load complist before calling compinit.
# See https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Use-of-compinit
zmodload zsh/complist

# Set the completion dump file path.
# Utilises the XDG_CACHE_HOME if available, falls back to home directory.
local zcompdump=${1:-${ZSH_COMPDUMP:-${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump}}
[[ -d "$zcompdump:h" ]] || mkdir -p "$zcompdump:h"

# Initialise completion system.
autoload -Uz compinit

# Determine whether to regenerate the completion dump file.
# If the dump file is older than 20 hours or if the force flag is set, it is regenerated.
# The force flag allows manual overriding of the default behavior for troubleshooting or updates.
# See https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Initialization
local force=0

if [[ "$1" == "-f" ]]; then
  force=1
  shift
fi

# Glob magic explained:
#   #q expands globs in conditional expressions
#   N - sets null_glob option (no error on 0 results)
#   mh-20 - modified less than 20 hours ago
if [[ $force -ne 1 ]] && [[ $zcompdump(#qNmh-20) ]]; then
  # -C (cached) implies -i.
  compinit -C -d "$zcompdump"
else
  compinit -i -d "$zcompdump" # -i (ignore insecure directories)
  touch "$zcompdump"
fi

# Asynchronously compile the completion dump on modification for better performance.
# This step is skipped if the dump is up-to-date or currently being compiled by another process.
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

# Use vim style keybinds in menu completion
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# Shift-Tab: Perform menu completion, like menu-complete, except that if a menu
# completion is already in progress, move to the previous completion rather than
# the next.
# See http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Completion.
[ -n "${terminfo[kcbt]}" ] && bindkey "${terminfo[kcbt]}" reverse-menu-complete

# Configure terminal in application mode for accurate key code interpretation.
# See http://zshwiki.org/home/zle/bindkeys#reading_terminfo.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }

  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

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


# Advanced completion styles
# See http://zsh.sourceforge.net/Doc/Release/Completion-System.html#Completion-Styles.
emulate -L zsh
setopt localoptions extendedglob

# Try smart-case completion, then case-insensitive, then partial-word, and then
# substring completion.
# See http://zsh.sourceforge.net/Doc/Release/Completion-Widgets.html#Completion-Matching-Control.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Z}{a-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' completer _expand _complete _ignored _approximate

# Number of errors allowed before completion is stopped.
# https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Standard-Tags
zstyle ':completion:*' max-errors 3 numeric
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

# Pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# =============================================================================
# Key Bindings
# =============================================================================
# Initialise editing command line
autoload -U edit-command-line && zle -N edit-command-line

# Enable interactive comments (# on the command line)
setopt interactivecomments

# The time the shell waits, in hundredths of seconds, for another key to be pressed
# when reading bound multi-character sequences.
KEYTIMEOUT=1 # corresponds to 10ms

# Use vim as the editor
export EDITOR=vim

# # Use vim style line editing in zsh
# bindkey -v
# # Movement
# bindkey -a 'gg' beginning-of-buffer-or-history
# bindkey -a 'G' end-of-buffer-or-history
# # Undo
# bindkey -a 'u' undo
# bindkey -a '^R' redo
# # Edit line
# bindkey -a '^V' edit-command-line
# # Backspace
# bindkey '^?' backward-delete-char
# bindkey '^H' backward-delete-char
# Option + Backspace doesn't work
# bindkey '^[^?' backward-delete-word
# # Ctrl-U
# bindkey "^U" backward-kill-line

# Use incremental search
bindkey "^R" history-incremental-search-backward

# Print previous command with Alt-N, where N is the number of arguments
bindkey -s '\e1' "!:0 \t"
bindkey -s '\e2' "!:0-1 \t"
bindkey -s '\e3' "!:0-2 \t"
bindkey -s '\e4' "!:0-3 \t"
bindkey -s '\e5' "!:0-4 \t"
bindkey -s '\e`' "!:0- \t"     # all but the last word

# bind C-Z to "fg", so the same keybind suspends and resumes
function fancy_ctrl_z() {
	if [[ $#BUFFER -eq 0 ]]; then
		export BUFFER='fg'
		zle accept-line
	else
		zle push-input
		zle clear-screen
	fi
}
zle -N fancy_ctrl_z
bindkey '^Z' fancy_ctrl_z

# # Update: switch entirely to vim keybinds. Removing everything else.
# # See
# # http://pubs.opengroup.org/onlinepubs/7908799/xcurses/terminfo.html#tag_002_001_003_003
# # for the table of terminfo, and see
# # http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets
# # for standard widgets of zsh.

# # Option + Left arrow for prev word
# bindkey '^[^[[D' backward-word
# # Option + Right arrow for next word
# bindkey '^[^[[C' forward-word
# # Will not work on mac: Ctrl + Left/Right arrow
# bindkey '^[[5D' beginning-of-line
# bindkey '^[[5C' end-of-line
# bindkey '^[[3~' delete-char

# =============================================================================
# History
# =============================================================================

# See 2.5.4 of http://zsh.sourceforge.net/Guide/zshguide02.html.
[ -z "$HISTFILE" ] && HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE

# Perform textual history expansion, csh-style, treating the character '!'
# specially.
unsetopt bang_hist

setopt hist_ignore_all_dups    # Delete an old recorded event if a new event is a duplicate.
setopt hist_ignore_space       # Do not record an event starting with a space.
setopt hist_reduce_blanks      # Remove extra blanks from commands added to the history list.
setopt hist_save_no_dups       # Do not write a duplicate event to the history file.
# If the internal history needs to be trimmed to add the current command line,
# setting this option will cause the oldest history event that has a duplicate
# to be lost before losing a unique event from the list.
setopt hist_expire_dups_first

# When searching for history entries in the line editor, do not display
# duplicates of a line previously found, even if the duplicates are not
# contiguous.
setopt hist_find_no_dups

# Do not enter command lines into the history list if they are duplicates of the
# previous event.
setopt hist_ignore_dups

# Whenever the user enters a line with history expansion, don't execute the line
# directly; instead, perform history expansion and reload the line into the
# editing buffer.
setopt hist_verify

# This options works like APPEND_HISTORY except that new history lines are added
# to the $HISTFILE incrementally (as soon as they are entered), rather than
# waiting until the shell exits.
setopt inc_append_history

# Save each command’s beginning timestamp (in seconds since the epoch) and the
# duration (in seconds) to the history file. The format of this prefixed data is:
# ‘: <beginning time>:<elapsed seconds>;<command>’.
setopt extended_history

setopt NO_hist_beep            # Don't beep when accessing non-existent history.
setopt NO_share_history        # Don't share history between all sessions.

# =============================================================================
# Input/Output
# =============================================================================

# If this option is unset, output flow control via start/stop characters
# (usually assigned to ^S/^Q) is disabled in the shell's editor.
unsetopt flow_control

# https://zsh.sourceforge.io/Doc/Release/Shell-Builtin-Commands.html#index-r
# Disable zsh builtin redo command alias. Use `fc -e -` or `!!` if needed.
disable r
