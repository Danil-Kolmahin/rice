# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=999999999
SAVEHIST=999999999
# End of lines configured by zsh-newuser-install

setopt prompt_subst
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY

preexec() {
  print -Pn "\e]0;Terminal - $1\a" # set terminal title to first cmd word

  PROMPT_TIMER=$(date +%s%3N)
}

precmd() {
  print -Pn "\e]0;Terminal\a" # set terminal title back

  if [ $PROMPT_TIMER ]; then
    local elapsed=$(($(date +%s%3N) - $PROMPT_TIMER))
    PROMPT_ELAPSED=$(printf "%d.%#.3d" $((elapsed / 1000)) $((elapsed % 1000)))
    unset PROMPT_TIMER
  fi

  PROMPT_TIME=$(date +'%H:%M:%S.%3N')
}


PROMPT='%F{%(?.green.red)}%? %F{yellow}${PROMPT_TIME}${PROMPT_ELAPSED:+ "%F{blue}${PROMPT_ELAPSED}"} %F{magenta}%n%F{brightwhite}@%F{white}%m %F{cyan}%~ %f
>'

alias l='ls -lah --color=auto'
alias e='$EDITOR'
alias remem='$EDITOR "$HOME/.local/share/remem.md"'

h() {
  history -t'%F %T' -D 1 | less +G
}

_read_input() {
  # TODO: rewrite this and reliant functions to work in all this cases:
  # en2uk hello 
  # en2uk "hello world"
  # echo "hello" | en2uk
  # en2uk ./path/to/file
  # en2uk # - starts interactive prompt
  if [ ! -t 0 ]; then
    cat
  elif [ "${#@}" -eq 1 ] && [ -f "$1" ]; then
    cat "$1"
  elif [ "${#@}" -gt 0 ]; then
    echo "$*"
  else
    vared -p "text: " -c text
    echo "$text"
  fi
}

spell-uk() { _read_input "$@" | languagetool -l uk-UA - 2>/dev/null }
spell-en() { _read_input "$@" | languagetool -m uk-UA -l en-US - 2>/dev/null }

en2uk() { ~/.local/share/argos-env/bin/argos-translate -f en -t uk "$(_read_input "$@")" 2>/dev/null }
uk2en() { ~/.local/share/argos-env/bin/argos-translate -f uk -t en "$(_read_input "$@")" 2>/dev/null }

# Fast nvm lazy-load (avoids ~300ms init on every terminal open)
# See: https://github.com/nvm-sh/nvm/issues/2724
_load_nvm() {
  unfunction nvm node npm npx yarn 2>/dev/null
  [ -s /usr/share/nvm/init-nvm.sh ] && . /usr/share/nvm/init-nvm.sh

  # Auto-switch version based on .nvmrc (runs once on first trigger)
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ "$(nvm version)" != "$(nvm version default)" ]; then
    nvm use default
  fi
}

nvm()   { _load_nvm; nvm   "$@"; }
node()  { _load_nvm; node  "$@"; }
npm()   { _load_nvm; npm   "$@"; }
npx()   { _load_nvm; npx   "$@"; }
yarn()  { _load_nvm; yarn  "$@"; }
