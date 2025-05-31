_pip_completion() {
	local words cword
	read -Ac words
	read -cn cword
	reply=($(COMP_WORDS="$words[*]" \
		COMP_CWORD=$((cword - 1)) \
		PIP_AUTO_COMPLETE=1 $words[1] 2>/dev/null))
}

compctl -K _pip_completion pip

_github() {
  local curcontext="$curcontext" state line ret=1
  local -a repos
  
  _arguments -C \
    '1: :->repo' \
    '*::arg:->args' && ret=0
  
  case $state in
    repo)
      # Only query if at least 3 characters are typed to avoid rate limiting
      if [[ ${#words[CURRENT]} -ge 3 ]]; then
        # Query GitHub API for repositories matching the input
        repos=(${(f)"$(curl -s "https://api.github.com/search/repositories?q=${words[CURRENT]}&per_page=15" | 
               jq -r '.items[].full_name')"})
               
        # Add descriptions (optional)
        local -a descriptions
        descriptions=(${(f)"$(curl -s "https://api.github.com/search/repositories?q=${words[CURRENT]}&per_page=15" | 
                     jq -r '.items[] | .full_name + ":" + (.description | if . == null then "" else . end)')"})
        
        local -a display_repos
        for desc in $descriptions; do
          local repo="${desc%%:*}"
          local description="${desc#*:}"
          # Trim description if too long
          if [[ ${#description} -gt 50 ]]; then
            description="${description[1,50]}..."
          fi
          display_repos+=("$repo:$description")
        done
        
        _describe -t repositories 'GitHub repositories' display_repos && ret=0
      fi
      ;;
    args)
      # No further completion after the repository name
      ;;
  esac
  
  return ret
}

compdef _github github
