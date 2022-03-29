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


### ZSH Settings
source ~/.zsh/settings.zsh

# source the theme
# shellcheck source=/dev/null
. ~/.zsh/powerlevel10k.zsh
# source the plugins and start completions/autosuggestions.
# shellcheck source=.zsh/zinit.zsh
export IN_ZINIT=1
. ~/.zsh/zinit.zsh

### Set up sandboxd for slow packages
# https://github.com/benvan/sandboxd
# source $dotfiles/.sandboxd



#### Shell Setup
# dotfiles=~/.shell/

# # load dotfiles
# for file in $dotfiles/{aliases,export,functions,inputrc}.sh; do
#     [ -r "$file" ] && [ -f "$file" ] && source "$file";
# done;

#
# zsh-substring-completion
#
setopt complete_in_word
setopt always_to_end
WORDCHARS=''
zmodload -i zsh/complist

# Substring completion
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'


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

### Profiling zsh
# zprof | head -n 20
