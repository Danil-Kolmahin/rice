# Lines configured by zsh-newuser-install
HISTFILE="$XDG_STATE_HOME"/zsh/.histfile
HISTSIZE=999999999
SAVEHIST=999999999
# End of lines configured by zsh-newuser-install

setopt PROMPT_SUBST
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY_TIME

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
# TODO: automate argos-translate installation (AUR is broken)
# uv venv ~/.local/share/argos-env --python 3.12 # maybe `sudo uv pip install --system pip` needed
# uv pip install --python ~/.local/share/argos-env argostranslate
# ~/.local/share/argos-env/bin/argospm install translate-en_uk

eval "$(fnm env --use-on-cd --version-file-strategy=recursive --resolve-engines --shell zsh)"

# TODO: if first time launch after chroot propose `rice --tags "all"`
