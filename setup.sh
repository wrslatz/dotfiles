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
printf "1. Change your default shell to zsh\n"
printf "2. Install Homebrew package manager\n"
printf "3. Install oh-my-zsh framework\n"
printf "4. Install chezmoi and apply wrslatz's dotfiles configuration\n"
read -p "Do you want to proceed? (y/n) " -n 1 -r
printf "\n"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    printf "Proceeding with setup...\n"
else
    printf "Setup aborted.\n"
    exit 1
fi

# Set shell to zsh, if necessary
if [ -n "$ZSH_VERSION" ]; then
    printf "Current shell is already zsh\n"
else
    printf "Changing shell to zsh...\n"
    chsh -s $(which zsh)
fi

# Install Homebrew, if necessary
if which -s brew; then
    printf 'Homebrew is already installed\n'
else
    printf 'Installing Homebrew...\n'
    # Only install Homebrew, do not modify shell files as they are managed by chezmoi
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install oh-my-zsh, if necessary
if [ -d "$HOME/.oh-my-zsh" ]; then
    printf "oh-my-zsh is already installed\n"
else
    printf "Installing oh-my-zsh...\n"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install chezmoi
/home/linuxbrew/.linuxbrew/bin/brew install chezmoi

# Initialize and apply chezmoi configuration
chezmoi init wrslatz
chezmoi diff

# Prompt yes or no before applying changes
read -p "Apply these changes? (y/n) " -n 1 -r
printf "\n"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    chezmoi apply -v
fi

# Finally, source zsh configuration to complete setup
printf "Sourcing zsh configuration to finalize setup...\n"
source ~/.zshrc
printf "Setup complete!"