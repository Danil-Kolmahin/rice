typeset -U path PATH

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

path=(~/.local/bin $path)
export PATH

export EDITOR=emacs
export VISUAL=emacs
# export PAGER=more
# export BROWSER=qutebrowser
# export TERMINAL=alacritty # @TERM
# export MANPAGER=???

export ELECTRON_OZONE_PLATFORM_HINT=auto # instead of --ozone-platform=wayland for apps like vscode
