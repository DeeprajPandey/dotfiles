# ZSH Options ref: http://zsh.sourceforge.net/Doc/Release/Options.html.
# From https://github.com/yous/vanilli.sh/blob/master/vanilli.zsh

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

# If a completion is performed with the cursor within a word, and a full
# completion is inserted, the cursor is moved to the end of the word.
setopt always_to_end

# If unset, the cursor is set to the end of the word if completion is started.
# Otherwise it stays there and completion is done from both ends.
setopt complete_in_word

# Don't beep on an ambiguous completion.
unsetopt list_beep

# Characters which are also part of a word.
# See 4.3.4 of http://zsh.sourceforge.net/Guide/zshguide04.html.
WORDCHARS=''



# Completion ref: https://thevaluable.dev/zsh-completion-guide-examples/
# Menu selection will be started unconditionally.
zstyle ':completion:*' menu select

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char

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

# Make sure the terminal is in application mode, which zle is active. Only then
# are the values from $terminfo valid.
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

# Shift-Tab: Perform menu completion, like menu-complete, except that if a menu
# completion is already in progress, move to the previous completion rather than
# the next.
# See http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Completion.
[ -n "${terminfo[kcbt]}" ] && bindkey "${terminfo[kcbt]}" reverse-menu-complete


# =============================================================================
# History
# =============================================================================

# Perform textual history expansion, csh-style, treating the character '!'
# specially.
unsetopt bang_hist

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

# See 2.5.4 of http://zsh.sourceforge.net/Guide/zshguide02.html.
[ -z "$HISTFILE" ] && HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# =============================================================================
# Input/Output
# =============================================================================

# If this option is unset, output flow control via start/stop characters
# (usually assigned to ^S/^Q) is disabled in the shell's editor.
unsetopt flow_control

# =============================================================================
# Key Bindings
# =============================================================================

# See
# http://pubs.opengroup.org/onlinepubs/7908799/xcurses/terminfo.html#tag_002_001_003_003
# for the table of terminfo, and see
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets
# for standard widgets of zsh.

# Home
[ -n "${terminfo[khome]}" ] && bindkey "${terminfo[khome]}" beginning-of-line
# End
[ -n "${terminfo[kend]}" ] && bindkey "${terminfo[kend]}" end-of-line
# Backspace
[ -n "${terminfo[kbs]}" ] && bindkey "${terminfo[kbs]}" backward-delete-char
# Delete
[ -n "${terminfo[kdch1]}" ] && bindkey "${terminfo[kdch1]}" delete-char
# Up-arrow
[ -n "${terminfo[kcuu1]}" ] && bindkey "${terminfo[kcuu1]}" up-line-or-history
# Down-arrow
[ -n "${terminfo[kcud1]}" ] && bindkey "${terminfo[kcud1]}" down-line-or-history
# Left-arrow
[ -n "${terminfo[kcub1]}" ] && bindkey "${terminfo[kcub1]}" backward-char
# Right-arrow
[ -n "${terminfo[kcuf1]}" ] && bindkey "${terminfo[kcuf1]}" forward-char
# Ctrl-U
bindkey "^U" backward-kill-line

autoload -Uz compinit && compinit

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
autoload edit-command-line

# Print previous command with Alt-N, where N is the number of arguments
bindkey -s '\e1' "!:0 \t"
bindkey -s '\e2' "!:0-1 \t"
bindkey -s '\e3' "!:0-2 \t"
bindkey -s '\e4' "!:0-3 \t"
bindkey -s '\e5' "!:0-4 \t"
bindkey -s '\e`' "!:0- \t"     # all but the last word

# automatically escape pasted URLs
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic
# autoload -Uz url-quote-magic
# zle -N self-insert url-quote-magic

# reload the zsh session. From OMZ:plugins/zsh_reload
zreload() {
	local cache="$ZSH_CACHE_DIR"
	autoload -U compinit zrecompile
	compinit -i -d "$cache/zcomp-$HOST"

	for f in ${ZDOTDIR:-~}/.zshrc "$cache/zcomp-$HOST"; do
		zrecompile -p $f && command rm -f $f.zwc.old
	done

	# Use $SHELL if available; remove leading dash if login shell
	[[ -n "$SHELL" ]] && exec ${SHELL#-} || exec zsh
}