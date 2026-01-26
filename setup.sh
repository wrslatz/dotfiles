#!/bin/sh
# setup.sh: Setup script to initialize a new system with zsh, Homebrew, oh-my-zsh, and wrslatz's dotfiles managed by chezmoi.
# To download this script, run:
#   curl -fsSL https://raw.githubusercontent.com/wrslatz/dotfiles/main/setup.sh -o setup.sh
# Then, review the script to ensure you trust it, and then execute it with:
#   sh setup.sh
# You can remove the script after setup completes, if desired:
#   rm setup.sh

# Explain what the script does and prompt for confirmation
printf "This script will set up your system with the following:\n"
printf "1. Install and change your default shell to zsh\n"
printf "2. Install git (dependency of Homebrew)\n"
printf "3. Install Homebrew\n"
printf "4. Install oh-my-zsh framework\n"
printf "5. Install chezmoi and apply wrslatz's dotfiles configuration\n"
printf "Do you want to proceed? (y/n) "
read -r PROCEED_REPLY
printf "\n"
if [ "$PROCEED_REPLY" = "y" ] || [ "$PROCEED_REPLY" = "Y" ]; then
    printf "Proceeding with setup...\n"
else
    printf "Setup aborted.\n"
    exit 1
fi

# Install zsh, if necessary
if [ -n "$ZSH_VERSION" ]; then
    printf "Current shell is already zsh.\n"
else
    ZSH_PATH=$(command -v zsh)
    if [ -z "$ZSH_PATH" ]; then
        printf "zsh not found in PATH. Installing zsh...\n"
        sudo apt install zsh
    else
        printf "zsh is already installed.\n"
    fi
fi

# Set zsh as the default shell for the user, if not already set
CURRENT_SHELL=$(awk -F: -v user="$USER" '$1 == user {print $NF}' /etc/passwd)
if [ "$CURRENT_SHELL" != "$(command -v zsh)" ]; then
    printf "Changing default shell to zsh...\n"
    sudo usermod -s "$(command -v zsh)" "$USER"
else
    printf "Default shell is already zsh.\n"
fi

# Install git (prerequisite for Homebrew), if not already installed
if command -v git >/dev/null 2>&1; then
    printf 'git is already installed.\n'
else
    printf 'Installing git...\n'
    sudo apt install git
fi

# Install Homebrew, if necessary
if command -v brew >/dev/null 2>&1; then
    printf 'Homebrew is already installed.\n'
else
    printf 'Installing Homebrew...\n'
    # Only install Homebrew, do not modify shell files as they are managed by chezmoi
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Add Homebrew to PATH for the current session
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# Verify Homebrew installation
if command -v brew >/dev/null 2>&1; then
    printf "Homebrew installation verified.\n"
else
    printf "Homebrew installation failed. Exiting.\n"
    exit 1
fi

# Install oh-my-zsh, if necessary
if [ -d "$HOME/.oh-my-zsh" ]; then
    printf "oh-my-zsh is already installed.\n"
else
    printf "Installing oh-my-zsh...\n"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install chezmoi, if necessary
if command -v chezmoi >/dev/null 2>&1; then
    printf "chezmoi is already installed.\n"
else
    printf "Installing chezmoi...\n"
    brew install chezmoi
fi

# Initialize and apply chezmoi configuration
printf "Initializing chezmoi with wrslatz's dotfiles...\n"
chezmoi init wrslatz --verbose
chezmoi git pull

printf "Review changes to be applied by chezmoi...\n"
chezmoi diff

# Prompt yes or no before applying changes
printf "Apply these changes? (y/n) "
read -r APPLY_CHANGES_REPLY
printf "\n"
if [ "$APPLY_CHANGES_REPLY" = "y" ] || [ "$APPLY_CHANGES_REPLY" = "Y" ]; then
    chezmoi apply -v
else
    printf "Exiting.\n"
    exit 1
fi

printf "Setup complete! Please restart your terminal to apply all changes.\n"
