check_chezmoi_git_status(){
    printf "Checking for local chezmoi git changes...\n"
    if [ -n "$(chezmoi git -- status --porcelain)" ]; then
        printf "Error: chezmoi working directory is not clean. Please commit or stash changes before syncing chezmoi.\n"
        chezmoi git -- --no-pager diff
        return 1
    fi
    printf "chezmoi working directory is clean.\n"
    return 0
}

check_chezmoi_diff_status(){
    printf "Diffing chezmoi against local state...\n"
    if [ -n "$(chezmoi diff --no-pager)" ]; then
        printf "Error: chezmoi local changes are not synced to chezmoi. Please review chezmoi and local state, then apply and/or re-apply changes where needed.\n"
        chezmoi diff --no-pager
        return 1
    fi
    printf "chezmoi is in sync with local changes.\n"
    return 0
}

alias ls='ls --color' # list with color
alias ll='ls -ltraF'  # list all

# brew aliases
alias sync_brew='printf "Updating and applying ~/.Brewfile...\n" && chezmoi update --apply=false && chezmoi apply ~/.Brewfile && printf "~/.Brewfile updated and applied!\n"'
alias backup_brew='printf "Backing up brew to ~/.Brewfile and syncing w/ chezmoi...\n" && brew bundle dump --global --describe --force && chezmoi re-add ~/.Brewfile && printf "brew backup complete!\n"'
alias update_brew='printf "Updating brew and dependencies...\n" && brew update && (brew bundle check --global --verbose || brew bundle install --global --verbose) && brew upgrade && brew cleanup && printf "brew and dependencies updated!\n"'

# chezmoi aliases
alias diff_chezmoi='printf "Diffing chezmoi remote and local...\n" && chezmoi git pull && check_chezmoi_git_status && check_chezmoi_diff_status && printf "chezmoi remote and local are in sync.\n"'
alias sync_chezmoi='printf "Syncing chezmoi...\n" && diff_chezmoi && chezmoi update && printf "chezmoi updated!\n"'

# general aliases
alias update_tools='printf "Updating tools...\n" && sudo apt update && sudo apt upgrade && sudo apt autoremove && sync_chezmoi && update_brew && backup_brew && omz update && sync_chezmoi && printf "All tools updated!"'
alias update_os='sudo apt dist-upgrade && sudo do-release-upgrade -d'
alias src="source ~/.zshrc"
