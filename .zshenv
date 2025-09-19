typeset -U path PATH
path=(~/.local/bin $path)
export PATH

export ELECTRON_OZONE_PLATFORM_HINT=auto # instead of --ozone-platform=wayland for apps like vscode
