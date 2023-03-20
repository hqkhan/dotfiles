# ctrl-f live grep|grep, reuses the git-grep command
FZF_PREFIX=${FZF_PREFIX:-"fzf-git"}

# default bind is ^G
FZF_GIT_BIND=${FZF_GIT_BIND:-"^G"}
FZF_GIT_CMD=${FZF_GIT_CMD:-"git"}
FZF_ZLE_PREFIX=${FZF_ZLE_PREFIX:-${FZF_PREFIX}}

join-lines() {
  local item
  while read item; do
    echo -n "${(q)item} "
  done
}

# ctrl-f live grep|grep, reuses the git-grep command
fzf-rg-widget() {
  local RG_CMD="rg --hidden --column --line-number --no-heading --color=always --smart-case -g '!{.git,node_modules}/*' -- "
  local result=$(_${FZF_PREFIX}-gg ${RG_CMD} | join-lines);
  zle reset-prompt;
  LBUFFER+=$result
}
zle -N fzf-rg-widget
bindkey -r '^n'
bindkey '^n' fzf-rg-widget
