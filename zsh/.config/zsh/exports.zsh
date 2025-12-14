# export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export EDITOR="nvim"
export VISUAL="nvim"

export HISTFILE=~/.cache/.zsh_history
export HISTSIZE=5000
export SAVEHIST=5000

export NVIMCONF=~/.config/nvim
export NVIMRC=~/.config/nvim/init.lua
export zshrc=~/.config/zsh/.zshrc

export PATH="/home/afnan/.local/bin":$PATH
export PATH="/home/afnan/.cargo/bin":$PATH
# export PATH="/home/afnan/.local/share/gem/ruby/3.4.0/bin":$PATH

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

export STARSHIP_CONFIG=~/.config/starship/starship.toml
export XDG_CONFIG_HOME="$HOME/.config"
export GIT_CONFIG_GLOBAL="$HOME/.config/git/gitconfig"
export EZA_CONFIG_DIR="$HOME/.config/eza"
export EZA_COLORS="$HOME/.config/eza/theme.yml"
export ELECTRON_OZONE_PLATFORM_HINT=wayland

# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(zoxide init zsh)" 

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

export HYPRSHOT_DIR=/home/afnan/Media/screenshots
export WAKATIME_HOME=/home/afnan/.config/wakatime

export HYPRSWITCHER_LOG=quiet
