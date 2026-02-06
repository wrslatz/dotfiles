alias ls='ls --color' # list with color
alias ll='ls -ltraF'  # list all
alias sync_brew="chezmoi update --apply=false && chezmoi apply ~/.Brewfile"
alias backup_brew="brew bundle dump --global --describe --force && chezmoi re-add ~/.Brewfile"
alias update_brew="brew update && (brew bundle check --global || brew bundle install --global) && brew cleanup"
alias update_tools='sudo apt update && sudo apt upgrade && sudo apt autoremove && sync_brew && update_brew && backup_brew && omz update'
alias update_os='sudo apt dist-upgrade && sudo do-release-upgrade -d'
alias src="source ~/.zshrc"
alias backup_brew="brew bundle dump --global --describe --force"
alias update_brew="brew update && (brew bundle check --global || brew bundle install --global) && brew cleanup"
