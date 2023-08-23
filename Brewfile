# set arguments for all 'brew install --cask' commands
cask_args appdir: "~/Applications", require_sha: true

# Install essential tools
brew "wget"
brew "git"
brew "gpg" if OS.mac?
brew "glibc" if OS.linux?

# Install essential casks (GUI applications)
cask "docker"
cask "iterm2"
cask "visual-studio-code"
cask "whalebrew"
cask "firefox"
cask "keepassxc", greedy: true      # always upgrade
cask "protonvpn"
cask "aldente"
cask "monitorcontrol"
cask "google-drive"
# brew install --cask logi-options-plus     # iff 3S is on the desk

# Install font cask for nerd-fonts and such
# Font preview: https://www.programmingfonts.org/#source-code-pro
tap "homebrew/cask-fonts"
brew "font-source-code-pro-for-powerline"
# brew "font-fira-code-nerd-font"
# brew "font-hack-nerd-font"


# Install linux packages through Whalebrew
# https://github.com/whalebrew/whalebrew
whalebrew "whalebrew/ffmpeg"

# Install VSCode extensions
# generic extensions
vscode "yzhang.markdown-all-in-one"
vscode "DavidAnson.vscode-markdownlint"
vscode "VisualStudioExptTeam.vscodeintellicode"

# python specific extensions
vscode "ms-python.python"
vscode "njpwerner.autodocstring"
vscode "KevinRose.vsc-python-indent"
vscode "donjayamanne.python-environment-manager"

# containerising
vscode "ms-azuretools.vscode-docker"
vscode "ms-vscode-remote.remote-containers"