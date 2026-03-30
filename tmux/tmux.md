## Tmux Configuration

This directory contains the Tmux configuration managed by this dotfiles repository.
The configuration defines terminal multiplexer behavior, key bindings, and custom shell aliases related to Tmux.

### Files

#### `tmux.conf`

- Main Tmux configuration file.
- This file defines:
  - Tmux key bindings
  - Status bar configuration
  - Pane and window behavior
  - General Tmux preferences

- Installed to: `~/.tmux.conf`

#### `tmux_aliases.sh`

- Shell aliases for interacting with Tmux.
- This file is sourced by the shell configuration.

### Installation

- These files are installed via the dotfiles bootstrap process using symbolic links.
  Example:

  ```
  ln -s ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
  ```

- Shell aliases are loaded through the shell configuration (e.g., `.zshrc` or `.bashrc`).

### Repository

Part of the main dotfiles repository: `~/.dotfiles`

### Author

Simge Ekiz

### License

MIT License

## Tmux Cheatsheet

🧠 Basic Concepts
Session: Collection of windows.

Window: Like a tab; contains panes.

Pane: Subdivided terminal area.

🔑 Prefix Key
Default: Ctrl + b (denoted as C-b)

You can change it (e.g., to C-a) in .tmux.conf

🚀 Session Commands

| Action                 | Command/Shortcut                                                       |
| ---------------------- | ---------------------------------------------------------------------- |
| Start new session      | `tmux` or `tmux new -s <name>` or _`tmuxnew/tn`_ or _`tnt/tns <name>`_ |
| List sessions          | `tmux ls` or _`tls`_                                                   |
| Attach to session      | `tmux attach -t <name>` or _`ta`_(last session) or _`tat <name>`_      |
| Kill session           | `tmux kill-session -t <name>` or _`tkt/tkill <name>`_                  |
| Detach from session    | `Ctrl + B + d` or `td` or `tdetach`                                    |
| Rename current session | `tmux rename-session mysession` or `Ctrl + b $`                        |

🪟 Window Commands
| Action | Command/Shortcut |  
| -------------------------- | ---------------------------------------------------------------------- |  
| New window | `Ctrl + b c` |
| List windows | `Ctrl + b w` |
| Rename window | `Ctrl + b ,` |
| Switch window | `Ctrl + b n / C-b p` |
| Select window by number | `Ctrl + b <num>` |
| Kill current window | `Ctrl + b &` |

🧱 Pane Commands
| Action | Command/Shortcut |  
| -------------------------- | ---------------------------------------------------------------------- |  
| Split pane horizontally | `Ctrl + b "` |
| Split pane vertically | `Ctrl + b %` |
| Switch panes | `Ctrl + b o or arrow keys` |
| Resize pane | `Ctrl + b then Hold Ctrl + Arrow` |
| Kill pane | `Ctrl + b x` |
| Convert pane to window | `Ctrl + b !` |

📦 Copy & Paste (Copy Mode)
| Action | Command/Shortcut |  
| -------------------------- | ---------------------------------------------------------------------- |  
| Enter copy mode | `Ctrl + b [` |
| Move cursor | `Arrow keys / hjkl` |
| Start selection | `Space` |
| Copy selection | `Enter` |
| Paste buffer | `Ctrl + b ]` |
