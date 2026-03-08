# Tmux Configuration

A custom tmux configuration with vim-style keybindings, sane defaults, and a Nord-themed status bar powered by [tmux-powerkit](https://github.com/fabioluciano/tmux-powerkit).

## Features

- **Prefix key** remapped to `C-a` (instead of the default `C-b`)
- **Vi copy mode** with familiar `v` / `y` bindings
- **Pane navigation** without prefix using `C-h/j/k/l`
- **Window/pane numbering** starts at 1
- **Nord dark theme** via tmux-powerkit with status bar modules for disk, datetime, cpu, memory, git, and hostname

## Keybindings

### General

| Keybinding | Action |
|---|---|
| `C-a` | Prefix (leader) key |
| `prefix + r` | Reload tmux configuration |

### Panes

| Keybinding | Action |
|---|---|
| `prefix + \|` | Split pane horizontally |
| `prefix + -` | Split pane vertically |
| `C-h` | Move to left pane |
| `C-j` | Move to pane below |
| `C-k` | Move to pane above |
| `C-l` | Move to right pane |

### Copy Mode (vi)

| Keybinding | Action |
|---|---|
| `prefix + Escape` | Enter copy mode |
| `v` | Begin selection |
| `y` | Yank selection and exit copy mode |

## Plugins

Managed via [TPM](https://github.com/tmux-plugins/tpm) (Tmux Plugin Manager):

| Plugin | Description |
|---|---|
| [tmux-plugins/tpm](https://github.com/tmux-plugins/tpm) | Plugin manager |
| [tmux-plugins/tmux-sensible](https://github.com/tmux-plugins/tmux-sensible) | Sensible default settings |
| [fabioluciano/tmux-powerkit](https://github.com/fabioluciano/tmux-powerkit) | Status bar with theme support |

### Powerkit Configuration

- **Theme:** nord (dark variant)
- **Status bar modules:** disk, datetime, cpu, memory, git, hostname

## Installation

### Dependencies

- `tmux`
- `git`

### Quick Install

```bash
chmod +x install.sh
./install.sh
```

The install script will:

1. Detect your distribution (Debian/Ubuntu or Arch)
2. Install tmux and git via the appropriate package manager
3. Symlink `.tmux.conf` to `~/.config/tmux/.tmux.conf`
4. Clone TPM if not already present
5. Install all plugins via TPM

After installation, start a new tmux session:

```bash
tmux new-session
```
