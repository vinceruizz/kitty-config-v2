# Midnight Glass for Kitty

A dark, glassy terminal with soft colors, magenta tab labels, a clear active-tab
background, and JetBrainsMono Nerd Font. Works on **macOS and Linux**.

## Install

You need **Git** installed. On macOS, you also need [Homebrew](https://brew.sh).
Copy this entire block into your terminal—you can run it from any folder:

```sh
(
  set -eu
  kitty_setup_dir="$(mktemp -d)"
  trap 'rm -rf "$kitty_setup_dir"' EXIT
  git clone --depth 1 https://github.com/vinceruizz/kitty-config-v2.git "$kitty_setup_dir/config"
  sh "$kitty_setup_dir/config/install.sh" --install-deps --font
)
```

This installs Kitty, the font, and the config. **Your existing Kitty config is
backed up automatically.** The installer prints the backup's location. It uses
your Linux package manager or Homebrew and asks for administrator access only
when needed. **Do not put sudo in front of the whole block.**

Already have Kitty and the font? This block installs only the config:

```sh
(
  set -eu
  kitty_setup_dir="$(mktemp -d)"
  trap 'rm -rf "$kitty_setup_dir"' EXIT
  git clone --depth 1 https://github.com/vinceruizz/kitty-config-v2.git "$kitty_setup_dir/config"
  sh "$kitty_setup_dir/config/install.sh"
)
```

Config files go to `~/.config/kitty`, or your XDG config location. Close and reopen
Kitty to apply everything. You can also press **Ctrl+Shift+F5** to reload colors
and settings in an existing window.

## Optional: matching zsh prompt

If you use zsh, paste this after installing to add the matching prompt colors:

```sh
sh "${XDG_CONFIG_HOME:-$HOME/.config}/kitty/install.sh" --shell-integration
```

It backs up your `.zshrc`, adds the prompt setup once, and leaves your login shell
unchanged. Open a new terminal to see it. Bash and fish users can skip this step.

## Shortcuts

| Shortcut | Action |
| --- | --- |
| Ctrl+Shift+T | New tab |
| Ctrl+Shift+W | Close tab |
| Ctrl+Shift+Left / Right | Previous / next tab |
| Ctrl+Shift+F5 | Reload settings |
| Ctrl+Shift+F6 | Reset the window title to Kitty Terminal |

## Make it yours

| File | What to change |
| --- | --- |
| `current-theme.conf` | Colors and active/inactive tab backgrounds |
| `kitty.conf` | Font, font size, opacity, blur, padding and shortcuts |
| `midnight-glass.zsh` | Optional zsh prompt colors |

Opacity stays at **0.75** and blur at **30**. On Linux, transparency and blur
depend on your compositor; this installer does not change desktop settings.
Neovim has its own theme, so Kitty color changes will not replace Neovim's colors.

## Preview or restore

To preview the installer's actions without changing anything:

```sh
sh "${XDG_CONFIG_HOME:-$HOME/.config}/kitty/install.sh" --dry-run
```

For all options, replace `--dry-run` with `--help`.

To restore a backup, close Kitty, move the new config aside, and put the reported
backup back at its original location. Unpack `.tar.gz` backups into a separate
folder before restoring. Shell prompt backups are saved beside your `.zshrc`.

<details>
<summary>Linux compatibility and advanced options</summary>

- Config deployment works across Linux distributions without root or a package
  manager. Use the config-only block if Kitty is already installed another way.
- Optional dependency installation supports apt, dnf, yum, pacman, zypper, apk,
  xbps, emerge, eopkg and Nix profiles. Repositories must provide Kitty. Nix needs
  flakes/nix-command enabled.
- On immutable systems, install Kitty through the host's supported method, then
  use the config-only block. For other installation methods, see
  [Kitty's installation guide](https://sw.kovidgoyal.net/kitty/binary/).
- `--target` chooses another config directory. Use `kitty --config` to launch
  with a config outside Kitty's usual location.
- macOS-only Kitty options are ignored on Linux. Blur support varies; see
  [Kitty's blur settings](https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.background_blur).
- A symlinked `.zshrc` needs manual prompt setup. The installer respects ZDOTDIR
  and preserves an existing Midnight Glass prompt setup.
- Rerunning in place creates a `.tar.gz` backup without replacing the config
  directory. Backups are never automatically deleted.

</details>
