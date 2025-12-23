#!/bin/bash

echo "Starting setup..."
echo "Updating and installing packages..."
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install -y git curl wget build-essential bat gh zsh jq lf starship stow fzf ripgrep fd find

echo "Stowing dotfiles..."
stow zsh starship tmux git nvim bat lf

restart

echo "Setup complete!"

