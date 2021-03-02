# If not running interactively, don't do anything
[[ -o interactive ]] || returni

### For profiling zsh
# zmodload zsh/zprof

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk
if [ -e /Users/pontiac/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/pontiac/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

### Common ICE modifiers
z_lucid() {
	zinit ice lucid ver'master' "$@"
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

### New cd that learns
# zi0a
# zinit light skywind3000/z.lua


#### ZSH Essentials

zi0a blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

zi0a pick'autopair.zsh'
zinit light hlissner/zsh-autopair

### Slow - replaced with exa separately (shell/alias.sh)
### k: better than ls
# zi0a
# zinit light supercrabtree/k

### Load this last to avoid bug where suggestion prints twice
zi0a blockf atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

#### Extra Plugins
zi_program() {
	zi0a as'program' "$@"
}

### Insult me if I type a wrong command
zi0a pick'src/bash.command-not-found'
zinit light hkbakke/bash-insulter

### NOT NEEDED
### URL encoder/decoder
# zi_program pick'hURL'
# zinit light 'fnord0/hURL'


#### Setup

dotfiles=~/.shell/

### Set up sandboxd for slow packages
# https://github.com/benvan/sandboxd
# source $dotfiles/.sandboxd

### Load dotfiles
for file in $dotfiles/{export,alias,functions,inputrc}.sh; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;

export PATH="/usr/local/sbin:$PATH"

### Go and Protobuf
# export GOROOT=/usr/local/go
# export GOPATH=$HOME/go
# export GOBIN=$GOPATH/bin
# export PATH=$PATH:$GOROOT:$GOPATH:$GOBIN

### To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

### Show exit codes
typeset -g POWERLEVEL10K_STATUS_ERROR=true

### Less distractive colorscheme
typeset -g POWERLEVEL10K_TIME_FOREGROUND=238
typeset -g POWERLEVEL10K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=242
typeset -g POWERLEVEL10K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=226

##
 # lscolors
 ##
autoload -U colors && colors
export LSCOLORS="Gxfxcxdxbxegedxbagxcad"
export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=0;41:sg=30;46:tw=0;42:ow=30;43"
export TIME_STYLE='long-iso'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

#
# zsh-substring-completion
#
setopt complete_in_word
setopt always_to_end
WORDCHARS=''
zmodload -i zsh/complist

# Substring completion
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# References:
#   https://stackoverflow.com/a/43087047
#   https://github.com/zsh-users/zsh/blob/96a79938010073d14bd9db31924f7646968d2f4a/Src/Zle/zle_keymap.c#L1437-L1439
#   https://github.com/yous/dotfiles/commit/c29bf215f5a8edc6123819944e1bf3336a4a6648
if (( $+commands[vim] )); then
  export EDITOR=vim
  bindkey -e
fi

# Temp bin - primarily used for tmpmail
export PATH="$PATH:~/.dotfiles/tmpbin"

### zsh-users highlighting has bugs when used with zsh-autosuggestions
zi0c atinit'zpcompinit; zpcdreplay'
zinit light zdharma/fast-syntax-highlighting

### Profiling zsh
# zprof | head -n 20

# The next line updates PATH for the Google Cloud SDK.
#if [ -f '/Users/pontiac/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/pontiac/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
#if [ -f '/Users/pontiac/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/pontiac/google-cloud-sdk/completion.zsh.inc'; fi

# Add the following to your shell init to set up gpg-agent automatically for every shell
#if [ -f ~/.gnupg/.gpg-agent-info ] && [ -n "$(pgrep gpg-agent)" ]; then
#    source ~/.gnupg/.gpg-agent-info
#    export GPG_AGENT_INFO
#else
#    eval $(gpg-agent --daemon)
#fi

## NVM
export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

## Run executable from local node_modules/
# https://web.archive.org/web/20200812154305/https://2ality.com/2016/01/locally-installed-npm-executables.html
function npm-do { (PATH=$(npm bin):$PATH; eval $@;) }
