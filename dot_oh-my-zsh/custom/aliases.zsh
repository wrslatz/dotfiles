alias ls='ls --color' # list with color
alias ll='ls -ltraF'  # list all
alias update_tools='sudo apt update && sudo apt upgrade && sudo apt autoremove && brew update && (brew bundle check --global || brew bundle install --global) && brew cleanup && omz update'
alias update_os='sudo apt dist-upgrade && sudo do-release-upgrade -d'
alias src="source ~/.zshrc"
