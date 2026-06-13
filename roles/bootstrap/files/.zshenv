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
export TERMINAL=alacritty
# [ -n "$DISPLAY" ] && export BROWSER=qutebrowser || export BROWSER=todo # TODO: find non-gui browser # TODO: fix conflict found in vm with `xdg-settings set default-web-browser`

# XDG
export PYTHON_HISTORY="$XDG_STATE_HOME"/python_history
export PI_CODING_AGENT_DIR="$XDG_CONFIG_HOME"/pi/agent
export PASSWORD_STORE_DIR="$XDG_DATA_HOME"/pass
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export NPM_CONFIG_INIT_MODULE="$XDG_CONFIG_HOME"/npm/config/npm-init.js
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME"/npm
export NPM_CONFIG_TMP="$XDG_RUNTIME_DIR"/npm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
export NODE_REPL_HISTORY="$XDG_STATE_HOME"/node_repl_history
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME"/aws/credentials
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME"/aws/config
export ANSIBLE_HOME="$XDG_DATA_HOME"/ansible # TODO: fix, does not have effect
export CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME"/claude

export ELECTRON_OZONE_PLATFORM_HINT=auto # instead of --ozone-platform=wayland for apps like vscode
