# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=999999999
SAVEHIST=999999999
# End of lines configured by zsh-newuser-install

setopt prompt_subst
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY

preexec() {
  PROMPT_TIMER=$(date +%s%3N)
}

precmd() {
  if [ $PROMPT_TIMER ]; then
    local elapsed=$(($(date +%s%3N) - $PROMPT_TIMER))
    PROMPT_ELAPSED=$(printf "%d.%#.3d" $((elapsed / 1000)) $((elapsed % 1000)))
    unset PROMPT_TIMER
  fi

  PROMPT_TIME=$(date +'%H:%M:%S.%3N')
}


PROMPT='%F{%(?.green.red)}%? %F{yellow}${PROMPT_TIME} ${PROMPT_ELAPSED:+%F{brightyellow}${PROMPT_ELAPSED} }%F{magenta}%n%F{brightwhite}@%F{white}%m %F{cyan}%~ %f
>'

alias l='ls -lah --color=auto'
alias h="history -t'%F %T' -D 1"

# TODO: fix nvm slowness https://github.com/nvm-sh/nvm/issues/2724
# . /usr/share/nvm/init-nvm.sh # enable nvm

# # enable auto nvm
# autoload -U add-zsh-hook
# load-nvmrc() {
#   local nvmrc_path
#   nvmrc_path="$(nvm_find_nvmrc)"

#   if [ -n "$nvmrc_path" ]; then
#     local nvmrc_node_version
#     nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

#     if [ "$nvmrc_node_version" = "N/A" ]; then
#       nvm install
#     elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
#       nvm use
#     fi
#   elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
#     echo "Reverting to nvm default version"
#     nvm use default
#   fi

#   # TODO: possibly faster opens terminal
#   # if [[ $PWD == $PREV_PWD ]]; then
#   #   return
#   # fi

#   # if [[ "$PWD" =~ "$PREV_PWD" && ! -f ".nvmrc" ]]; then
#   #   return
#   # fi

#   # PREV_PWD=$PWD
#   # if [[ -f ".nvmrc" ]]; then
#   #   nvm use
#   #   NVM_DIRTY=true
#   # elif [[ $NVM_DIRTY = true ]]; then
#   #   nvm use default
#   #   NVM_DIRTY=false
#   # fi
# }
# add-zsh-hook chpwd load-nvmrc
# load-nvmrc
