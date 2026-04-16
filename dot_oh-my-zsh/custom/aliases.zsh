check_chezmoi_git_status(){
    if [ -n "$(chezmoi git -- status --porcelain)" ]; then
        echo "Error: chezmoi working directory is not clean. Please commit or stash changes before syncing chezmoi."
        chezmoi git -- --no-pager diff
        return 1
    fi
    return 0
}

alias ls='ls --color' # list with color
alias ll='ls -ltraF'  # list all
alias sync_brew='printf "Updating and applying ~/.Brewfile...\n" && chezmoi update --apply=false && chezmoi apply ~/.Brewfile && printf "~/.Brewfile updated and applied!\n"'
alias backup_brew='printf "Backing up brew to ~/.Brewfile and syncing w/ chezmoi...\n" && brew bundle dump --global --describe --force && chezmoi re-add ~/.Brewfile && printf "brew backup complete!\n"'
alias update_brew='printf "Updating brew and dependencies...\n" && brew update && (brew bundle check --global || brew bundle install --global) && brew upgrade && brew cleanup && printf "brew and dependencies updated!\n"'
alias diff_chezmoi="chezmoi git pull && check_chezmoi_git_status && chezmoi diff"
alias sync_chezmoi='printf "Diffing and syncing chezmoi...\n" && diff_chezmoi && chezmoi update && printf "chezmoi updated!\n"'
alias update_tools='printf "Updating tools...\n" && sudo apt update && sudo apt upgrade && sudo apt autoremove && diff_chezmoi && sync_chezmoi && update_brew && backup_brew && omz update && sync_chezmoi && printf "All tools updated!"'
alias update_os='sudo apt dist-upgrade && sudo do-release-upgrade -d'
alias src="source ~/.zshrc"
