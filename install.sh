#!/bin/sh
# Install this Kitty config on macOS or Linux.
set -eu
app=kitty
source_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
. "$source_dir/scripts/install-common.sh"
install_deps=0; font=0; shell_integration=0; dry_run=0
target="${XDG_CONFIG_HOME:-$HOME/.config}/kitty"
usage() {
    cat <<'HELP'
Usage: sh install.sh [options]
  --target /absolute/path  Destination (default: $XDG_CONFIG_HOME/kitty)
  --install-deps           Install Kitty with Homebrew/system package manager
  --font                   Install JetBrainsMono Nerd Font for this user
  --shell-integration      Add the supplied prompt colors to your .zshrc
  --config-only            Copy/backup config only (the default)
  --dry-run                Print the plan without writing or downloading anything
  --help                   Show this help
No sudo is used unless --install-deps is given. Existing configs are backed up.
Opacity and blur settings are preserved; Linux blur needs compositor support.
HELP
}
while [ "$#" -gt 0 ]; do
    case "$1" in
        --target) [ "$#" -ge 2 ] || fail '--target needs a path'; target=$2; shift ;;
        --install-deps) install_deps=1 ;;
        --font) font=1 ;;
        --shell-integration) shell_integration=1 ;;
        --config-only) install_deps=0; font=0; shell_integration=0 ;;
        --dry-run) dry_run=1 ;;
        --help|-h) usage; exit 0 ;;
        *) fail "Unknown option: $1" ;;
    esac
    shift
done
case "$target" in /*) ;; *) fail '--target must be absolute.' ;; esac
if [ "$dry_run" = 1 ]; then
    note "Platform: $platform; source: $source_dir; destination: $target"
    note "Backup existing config; install-deps=$install_deps; font=$font; zsh-integration=$shell_integration"
    exit 0
fi
if [ "$install_deps" = 1 ]; then install_packages; fi
deploy_files "$source_dir" "$target" kitty.conf current-theme.conf startup.session fixed_window_title.py midnight-glass.zsh install.sh scripts README.md
if [ "$font" = 1 ]; then install_font; fi
if [ "$shell_integration" = 1 ]; then
    zshrc="${ZDOTDIR:-$HOME}/.zshrc"
    [ ! -L "$zshrc" ] || fail "Refusing to append through a .zshrc symlink. Add the source line from README.md manually."
    shell_path=$(printf '%s' "$target/midnight-glass.zsh" | sed "s/'/'\\\\''/g")
    shell_line="[ ! -r '$shell_path' ] || . '$shell_path'"
    if [ -f "$zshrc" ] && grep -F 'midnight-glass.zsh' "$zshrc" >/dev/null 2>&1; then
        note "Existing Midnight Glass integration found in $zshrc; unchanged."
    else
        if [ -e "$zshrc" ]; then cp -p "$zshrc" "$zshrc.backup-$(date +%Y%m%d-%H%M%S)-$$"; fi
        mkdir -p "$(dirname "$zshrc")"
        printf '\n# Kitty Midnight Glass prompt colors\n%s\n' "$shell_line" >> "$zshrc"
        note "Added prompt integration: $zshrc (restart zsh to apply)."
    fi
fi
kitty_command=
if have kitty; then kitty_command=$(command -v kitty)
elif [ -x /Applications/kitty.app/Contents/MacOS/kitty ]; then kitty_command=/Applications/kitty.app/Contents/MacOS/kitty
elif [ -x "$HOME/.local/kitty.app/bin/kitty" ]; then kitty_command="$HOME/.local/kitty.app/bin/kitty"
fi
if [ -n "$kitty_command" ]; then
    KITTY_INSTALL_CONFIG="$target/kitty.conf" "$kitty_command" +runpy \
        'import os; from kitty.config import load_config; errors = []; load_config(os.environ["KITTY_INSTALL_CONFIG"], accumulate_bad_lines=errors); assert not errors, errors; print("Kitty configuration valid")'
else
    note 'Config installed. Install Kitty before launching: https://sw.kovidgoyal.net/kitty/binary/'
fi
note 'Done. Restart Kitty or press Ctrl+Shift+F5. Linux blur depends on your compositor.'
