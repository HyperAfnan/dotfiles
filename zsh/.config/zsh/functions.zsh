z() {
	if [ -n "$1" ]; then
		builtin z "$@" && eza -a
	else
		builtin z ~ && eza -a
	fi
}

h() {
	history 0 | grep $1
}

ya() {
	for pkg in $@; do
		yarn add $pkg
		yarn add -D @types/$pkg &>/dev/null || echo "No separate types for $pkg"
	done
}

yr() {
	for pkg in $@; do
		yarn remove $pkg
		yarn remove @types/$pkg &>/dev/null
	done
}

mkc() {
	mkdir -p "$1" && cd "$1" || return 1
}

batdiff() {
	git diff --name-only --diff-filter=d | xargs bat --diff
}

gitignore() {
	touch .gitignore
	for files in $@; do
		echo "${files}" >>.gitignore
	done
}

ff() {
  IFS=$'\n' files=($(
    find . \( -path '*/node_modules/*' -prune \) -o -type f -print \
    | fzf --query="$1" --multi --select-1 --exit-0 --prompt 'files:'
  ))
  [[ -n "$files" ]] && ${EDITOR} "${files[@]}"
}

cdf() {
   cd $(fd --type d --hidden --exclude .git --exclude node_module --exclude .cache --exclude .npm  | fzf)
}

addToPath() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH=$PATH:$1
    fi
}

restart() {
    source ~/.config/zsh/.zshrc
    clear
    echo "Shell Restarted"
}

rmf() {
  if [[ "$#" -eq 0 ]]; then
    local files
    files=$(find . -maxdepth 1 -type f | fzf --multi)
    echo $files | xargs -I '{}' rm {} 
  else
    command rm "$@"
  fi
}

fzf-aliases() {
    CMD=$(
        (
            (alias)
            (functions | grep "()" | cut -d ' ' -f1 | grep -v "^_" )
        ) | fzf | cut -d '=' -f1
    );

    eval $CMD
}

fzf-git-status() {
    git rev-parse --git-dir > /dev/null 2>&1 || { echo "You are not in a git repository" && return }
    local selected
    selected=$(git -c color.status=always status --short |
        fzf "$@" --border -m --ansi --nth 2..,.. \
        --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
        cut -c4- | sed 's/.* -> //')
            if [[ $selected ]]; then
                for prog in $(echo $selected);
                do; $EDITOR $prog; done;
            fi
    }
fzf-checkout(){
    if git rev-parse --git-dir > /dev/null 2>&1; then
        if [[ "$#" -eq 0 ]]; then
            local branches branch
            branches=$(git branch -a) &&
            branch=$(echo "$branches" |
            fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
            git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
        elif [ `git rev-parse --verify --quiet $*` ] || \
             [ `git branch --remotes | grep  --extended-regexp "^[[:space:]]+origin/${*}$"` ]; then
            echo "Checking out to existing branch"
            git checkout "$*"
        else
            echo "Creating new branch"
            git checkout -b "$*"
        fi
    else
        echo "Can't check out or create branch. Not in a git repo"
    fi
}

fzf-cd-incl-hidden() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
  ls
}
