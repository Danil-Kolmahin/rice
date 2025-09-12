# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=999999999
SAVEHIST=999999999
# End of lines configured by zsh-newuser-install

setopt prompt_subst

precmd() {
  export PROMPT_TIME=$(date +'%H:%M:%S.%3N')
}

PROMPT="""\
%F{%(?.green.red)}%? \
%F{yellow}${PROMPT_TIME} \
%F{magenta}%n\
%F{brightwhite}@\
%F{white}%m \
%F{cyan}%~ \
%f
>\
"""
