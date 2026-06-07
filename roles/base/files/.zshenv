typeset -U path PATH

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

path=(~/.local/bin $path)
export PATH

# export PAGER=more
# export MANPAGER=???
export EDITOR=emacs
export VISUAL=emacs
export TERMINAL=$TERM
[ -n "$DISPLAY" ] && export BROWSER=qutebrowser || export BROWSER=todo # TODO: find non-gui browser

export ELECTRON_OZONE_PLATFORM_HINT=auto # instead of --ozone-platform=wayland for apps like vscode
