typeset -U path PATH
path=(~/.local/bin $path)
export PATH

export ELECTRON_OZONE_PLATFORM_HINT=auto # instead of --ozone-platform=wayland for apps like vscode

# TODO: move to ~/.config/environment.d/defaults.conf, https://wiki.archlinux.org/title/Systemd/User#Basic_setup
export EDITOR=emacs
export VISUAL=emacs
# export PAGER=more
# export BROWSER=qutebrowser
# export TERMINAL=alacritty # @TERM
# export MANPAGER=???