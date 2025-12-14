alias c="clear"
alias ls="eza -a --icons"
alias q="exit"

alias cd="z"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias api="apt install"
alias aprm="apt remove"
alias apse="apt search"
alias apsh="apt show"
alias apu="apt update -y && apt upgrade -y"
alias apar="apt autoremove"

if command -v npq-hero >/dev/null 2>&1; then
  alias npm='npq-hero'
  alias yarn="NPQ_PKG_MGR=yarn npq-hero"
fi

alias y="yarn"
alias yga="yarn global add"
alias ygrm="yarn global remove"
alias yu="yarn upgrade"
alias ygu="yarn global upgrade"

alias rm="rm -rf"

alias v="nvim"
alias neovim="nvim"

alias mkdir="mkdir -p"

alias fzf="fzf --bind 'tab:toggle+up' --preview 'bat --color=always --style=numbers --line-range=:500 {}'"

alias mux="tmuxinator"

alias brave="brave --enable-features=UseOzonePlatform --ozone-platform=wayland"
