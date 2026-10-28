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

# zsh picks the vi keymap by itself when $EDITOR or $VISUAL contains "vi".
# Set emacs before anything (including compinit) binds keys into main.
bindkey -e

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

# =============================================================================
# Completion
# =============================================================================
# Ref: https://thevaluable.dev/zsh-completion-guide-examples/

# Since we are using menu-select, we need to load complist before calling compinit.
# See https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Use-of-compinit
zmodload zsh/complist

# A full compinit rescans fpath, so rebuild the dump at most once every 20h.
# To pick up new completions sooner: rm the dump and `exec zsh`.
# See https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Initialization
() {
  emulate -L zsh -o extended_glob
  local zcompdump=${ZSH_COMPDUMP:-${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump}
  [[ -d $zcompdump:h ]] || mkdir -p $zcompdump:h
  autoload -Uz compinit

  # (#qNmh-20): the dump exists and was modified within the last 20 hours.
  if [[ -n $zcompdump(#qNmh-20) ]]; then
    compinit -C -d $zcompdump
  else
    # compinit leaves an unchanged dump alone, so touch it to restart the 20h clock.
    compinit -i -d $zcompdump && touch $zcompdump
  fi

  # The lock dir stops shells started in parallel from compiling at the same time.
  {
    if [[ -s $zcompdump && ( ! -s $zcompdump.zwc || $zcompdump -nt $zcompdump.zwc ) ]]; then
      if command mkdir $zcompdump.zwc.lock 2>/dev/null; then
        zcompile $zcompdump
        command rmdir $zcompdump.zwc.lock 2>/dev/null
      fi
    fi
  } &!
}

# If a completion is performed with the cursor within a word, and a full
# completion is inserted, the cursor is moved to the end of the word.
setopt always_to_end

# If unset, the cursor is set to the end of the word if completion is started.
# Otherwise it stays there and completion is done from both ends.
setopt complete_in_word

setopt auto_menu            # Show completion menu on a successive tab press.
setopt auto_list            # Automatically list choices on ambiguous completion.
setopt auto_param_slash     # If completed parameter is a directory, add a trailing slash.
setopt NO_menu_complete     # Do not autoselect the first completion entry.

# Don't beep on an ambiguous completion.
unsetopt list_beep

# Menu selection starts with 2 or more matches.
zstyle ':completion:*' menu select=2

# Advanced completion styles
# See http://zsh.sourceforge.net/Doc/Release/Completion-System.html#Completion-Styles.

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
zstyle ':completion:*:messages' format ' %F{magenta} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

# Pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# Use vim style keybinds in menu completion
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# Shift-Tab: Perform menu completion, like menu-complete, except that if a menu
# completion is already in progress, move to the previous completion rather than
# the next.
# See http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Completion.
[[ -n ${terminfo[kcbt]} ]] && bindkey ${terminfo[kcbt]} reverse-menu-complete

# =============================================================================
# Expansion and Globbing
# =============================================================================

setopt extended_glob        # Enable ^, ~, # and (#q...) glob operators.

# =============================================================================
# History
# =============================================================================

# See 2.5.4 of http://zsh.sourceforge.net/Guide/zshguide02.html.
HISTFILE=${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history
[[ -d $HISTFILE:h ]] || mkdir -p $HISTFILE:h
HISTSIZE=500000
SAVEHIST=$HISTSIZE

# Treat '!' as a plain character: no !!/!$ history expansion, no quoting surprises.
unsetopt bang_hist

# NOTE: these need bang_hist to be enabled.
# # Print previous command with Alt-N, where N is the number of arguments
# bindkey -s '\e1' "!:0 \t"
# bindkey -s '\e2' "!:0-1 \t"
# bindkey -s '\e3' "!:0-2 \t"
# bindkey -s '\e4' "!:0-3 \t"
# bindkey -s '\e5' "!:0-4 \t"
# bindkey -s '\e`' "!:0- \t"     # all but the last word

setopt hist_ignore_all_dups    # Delete an old recorded event if a new event is a duplicate.
setopt hist_ignore_space       # Do not record an event starting with a space.
setopt hist_reduce_blanks      # Remove extra blanks from commands added to the history list.

# NOTE: `hist_ignore_all_dups` makes the following settings redundant. Leaving comments here
# for reference
#
## # Do not enter command lines into the history list if they are duplicates of the
## # previous event.
## setopt hist_ignore_dups
##
## setopt hist_save_no_dups       # Do not write a duplicate event to the history file.
##
## # If the internal history needs to be trimmed to add the current command line,
## # setting this option will cause the oldest history event that has a duplicate
## # to be lost before losing a unique event from the list.
## setopt hist_expire_dups_first

# When searching for history entries in the line editor, do not display
# duplicates of a line previously found, even if the duplicates are not
# contiguous.
setopt hist_find_no_dups

# # Whenever the user enters a line with history expansion, don't execute the line
# # directly; instead, perform history expansion and reload the line into the
# # editing buffer.
# # NOTE: this works only with bang_hist enabled (which is not now)
# setopt hist_verify

# Like inc_append_history, but writes each command after it finishes, so
# extended_history records its real duration.
setopt inc_append_history_time

# Save each command’s beginning timestamp (in seconds since the epoch) and the
# duration (in seconds) to the history file. The format of this prefixed data is:
# ‘: <beginning time>:<elapsed seconds>;<command>’.
setopt extended_history

setopt NO_hist_beep            # Don't beep when accessing non-existent history.
setopt NO_share_history        # Don't share history between all sessions.

# =============================================================================
# Input/Output
# =============================================================================

# Allow correction notifications when mistyping commands.
# `correct_all` is for all arguments.
# Zsh will suggest the closest match.
setopt correct

# Enable interactive comments (# on the command line)
setopt interactivecomments

setopt NO_flow_control      # Disable start/stop characters in shell editor.
# ^frees ^S/^Q in the line editor; with flow control on they pause/resume output

# https://zsh.sourceforge.io/Doc/Release/Shell-Builtin-Commands.html#index-r
# Disable zsh builtin redo command alias. Use `fc -e -` if needed.
disable r

# =============================================================================
# Job Control
# =============================================================================

# The prompt will display information about the status of a background job
# if it starts or stops. Useful if you background tasks often.
setopt notify

# =============================================================================
# Zle
# =============================================================================

# The time the shell waits, in hundredths of seconds, for another key to be pressed
# when reading bound multi-character sequences.
# Corresponds to 40ms (safer over ssh in emacs mode where esc-prefixed seq. can arrive split)
KEYTIMEOUT=4

# Word motion and deletion (Option + left/right arrow, Option + Backspace) treat characters
# in WORDCHARS as part of a word. Drop '/' so they stop at each path component:
# Option+Backspace on ~/wd/dotfiles deletes "dotfiles", not the whole path.
# See 4.3.4 of http://zsh.sourceforge.net/Guide/zshguide04.html.
WORDCHARS=${WORDCHARS/\/}

# terminfo key entries (kcuu1, kcbt, ...) describe what keys send in application mode, so turn
# it on while zle is editing and off before a command runs.
# See http://zshwiki.org/home/zle/bindkeys#reading_terminfo.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
  function zle_application_mode_start { echoti smkx }
  function zle_application_mode_stop { echoti rmkx }
  autoload -Uz add-zle-hook-widget
  add-zle-hook-widget zle-line-init zle_application_mode_start
  add-zle-hook-widget zle-line-finish zle_application_mode_stop
fi

# Initialise editing command line
autoload -U edit-command-line && zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Option + left and right arrow as Alacritty sends them; iTerm's ^[b/^[f are already
# emacs defaults
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word

# Up/Down walk only entries that start with what's already typed (all history on
# an empty line). The arrows send ^[OA in application mode (what kcuu1/kcud1 hold)
# and ^[[A otherwise, so bind both.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# bind C-Z to "fg", so the same keybind suspends and resumes
function fancy_ctrl_z() {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER='fg'
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy_ctrl_z
bindkey '^Z' fancy_ctrl_z

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

# # Update: switch entirely to vim keybinds. Removing everything else.
# # See
# # http://pubs.opengroup.org/onlinepubs/7908799/xcurses/terminfo.html#tag_002_001_003_003
# # for the table of terminfo, and see
# # http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets
# # for standard widgets of zsh.

# # Will not work on mac: Ctrl + Left/Right arrow
# bindkey '^[[5D' beginning-of-line
# bindkey '^[[5C' end-of-line
# bindkey '^[[3~' delete-char
