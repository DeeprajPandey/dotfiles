
### [zinit] Common ICE modifiers
z_lucid() {
	zinit ice lucid ver'master' "$@"
}

z_lucid_dev() {
    zinit ice lucid-dev ver'master' "$@"
}

zi0a() {
	z_lucid wait'0a' "$@"
}

zi0b() {
	z_lucid wait'0b' "$@"
}

zi0c() {
	z_lucid wait'0c' "$@"
}

if [ "${TERM##*-}" = '256color' ] || [ "${terminfo[colors]:?}" -gt 255 ]; then
	z_lucid depth=1
	zinit light romkatv/powerlevel10k
fi


#### ZSH Essentials

zi0a
zinit light xPMo/zsh-toggle-command-prefix

zi0a blockf atload'_zsh_autosuggest_start'
zinit load zsh-users/zsh-autosuggestions

# end quotes, parens automatically
zi0a pick'autopair.zsh'
zinit light hlissner/zsh-autopair

# Insult me if I type a wrong command
zi0a pick'src/bash.command-not-found'
zinit light hkbakke/bash-insulter



# ## cd that learns (requires history, probably - setup later)
# zi0a
# zinit light skywind3000/z.lua

# ## slow - replaced with exa separately (shell/alias.sh)
# ## k: better than ls
# zi0a
# zinit light supercrabtree/k

# ## Load this last to avoid bug where suggestion prints twice
# zi0a blockf atload'_zsh_autosuggest_start'
# zinit light zsh-users/zsh-autosuggestions



# zinit light zsh-users/zsh-nvm
# zinit light zsh-users/zsh-new-up


##############
## Programs ##
##############

zi_program() {
	zi0a as'program' "$@"
}

# URL encoder/decoder
zi_program pick'hURL'
zinit light 'fnord0/hURL'

# Display thumbnails for images
zi_program has'mogrify'
zinit light 'hackerb9/lsix'

zi_program pick'prettyping' has'ping'
zinit light denilsonsa/prettyping

zi_program has'bat' pick'src/*'
zinit light eth-p/bat-extras

zi_program has'tmux' pick'bin/xpanes'
zinit light greymd/tmux-xpanes

zi_program pick'neofetch' atclone"cp neofetch.1 $HOME/.local/man/man1" atpull'%atclone'
zinit light dylanaraps/neofetch


#################
## Completions ##
#################

zi_completion() {
	zi0a as'completion' blockf "$@"
}

zi_completion has'tmux' pick'completion/zsh'
zinit light greymd/tmux-xpanes

zi_completion has'pandoc'
zinit light srijanshetty/zsh-pandoc-completion

# # music metadata fixing
# zi_completion has'beet'
# zinit snippet 'https://github.com/beetbox/beets/blob/master/extra/_beet'

# on Tab, show n permutations?
# zi0a blockf atpull'zinit creinstall -q .'
zi0b as'completion'
zinit light zsh-users/zsh-completions

zi_completion mv'git-completion.zsh -> _git'
zinit snippet https://github.com/git/git/blob/master/contrib/completion/git-completion.zsh


#################
## Shell Setup ##
#################
SHELL_COMMON=~/.shell/

zi0a pick'aliases.sh' multisrc'functions.sh export.sh'
zinit light $SHELL_COMMON

# Better tree: Canop/broot



# the following will run after everything else happens
finish_setup() {
	zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
	GPG_TTY="$(tty)" && export GPG_TTY
	[[ $COLORTERM = *(24bit|truecolor)* ]] || zmodload zsh/nearcolor
}

# better than zsh-users/zsh-syntax-highlighting
zi0c atinit'zpcompinit; zpcdreplay; finish_setup'
zinit light zdharma/fast-syntax-highlighting

# zinit light zsh-users/zsh-history-substring-search