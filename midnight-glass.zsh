# Shell colors for Midnight Glass. Source from ~/.zshrc.
# Apply only inside kitty; output uses kitty's default cream foreground.
if [[ -o interactive && ${TERM:-} == xterm-kitty ]]; then
    PROMPT='%F{#86dbf5}%~%f %F{#f5b66c}❯%f '

    # Preserve selection/search highlighting and existing ZLE widgets.
    # Re-sourcing this file replaces only the default input color.
    typeset -ga zle_highlight
    zle_highlight=("${(@)zle_highlight:#default:*}" 'default:fg=#ddd0f5')
fi
