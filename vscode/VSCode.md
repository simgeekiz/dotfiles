## VS Code Configuration

This directory contains Visual Studio Code configuration files managed as part of this dotfiles repository.
These files define personal editor preferences, keybindings, and development environment settings.

### Files

#### `settings.json`

- Visual Studio Code user settings.
- These settings configure the behavior and appearance of the editor, such as:
  - Editor preferences
  - Formatting rules
  - Language-specific settings
  - Extensions configuration
  - UI behavior
- Installed to: `$HOME/.config/Code/User/settings.json`

#### `keybindings.json`

- Custom keyboard shortcuts for Visual Studio Code.
- These bindings override the default keybindings to improve workflow and productivity.
- Installed to: `$HOME/.config/Code/User/keybindings.json`

### Installation

These files are installed via the dotfiles bootstrap process using symbolic links.
Example:

```
ln -s ~/.dotfiles/vscode/settings.json ~/.config/Code/User/settings.json
ln -s ~/.dotfiles/vscode/keybindings.json ~/.config/Code/User/keybindings.json
```

### Repository

Part of the main dotfiles repository:

`~/.dotfiles`

### Author

Simge Ekiz

### License

MIT License

---

### Shortcuts to remember

install the extentions

```
# Install extensions
xargs -n 1 code --install-extension < ~/.dotfiles/vscode/vscode-extensions.txt
<!-- cat ~/.dotfiles/vscode/vscode-extensions.txt | xargs -L 1 code --install-extension -->
```

- Check / Customize Shortcuts (Open Keyboard Shortcuts)

```
Go to File → Preferences → Keyboard Shortcuts (or press Ctrl + K, Ctrl + S).
```

- To render .md files

```
Ctrl + K V (Windows/Linux)
Or Cmd + K V (Mac)
```

- To format Document

```
Ctrl + Shift + I
```

- To format Selection

```
Select the code → Ctrl + K, Ctrl + F (Linux/Windows) / Cmd + K, Cmd + F (Mac)
```

🧭 Navigation

| Action                     | Windows / Linux    | macOS             |
| -------------------------- | ------------------ | ----------------- |
| Open Command Palette       | `Ctrl + Shift + P` | `Cmd + Shift + P` |
| Open terminal (integrated) | `Ctrl + `` `       | `Cmd + `` `       |
| Go to file                 | `Ctrl + P`         | `Cmd + P`         |
| Go to line                 | `Ctrl + G`         | `Cmd + G`         |
| Go to symbol in file       | `Ctrl + Shift + O` | `Cmd + Shift + O` |
| Toggle sidebar             | `Ctrl + B`         | `Cmd + B`         |

✍️ Editing

| Action            | Windows / Linux        | macOS                 |
| ----------------- | ---------------------- | --------------------- |
| Cut entire line   | `Ctrl + X`             | `Cmd + X`             |
| Copy entire line  | `Ctrl + C`             | `Cmd + C`             |
| Move line up/down | `Alt + ↑ / ↓`          | `Option + ↑ / ↓`      |
| Duplicate line    | `Shift + Alt + ↓`      | `Shift + Option + ↓`  |
| Duplicate line    | `Shift + Alt + ↑`      | `Shift + Option + ↑`  |
| Delete line       | `Ctrl + Shift + K`     | `Cmd + Shift + K`     |
| Insert line below | `Ctrl + Enter`         | `Cmd + Enter`         |
| Insert line above | `Ctrl + Shift + Enter` | `Cmd + Shift + Enter` |

🔍 Search & Replace

| Action           | Windows / Linux    | macOS             |
| ---------------- | ------------------ | ----------------- |
| Find             | `Ctrl + F`         | `Cmd + F`         |
| Replace          | `Ctrl + H`         | `Cmd + H`         |
| Find in files    | `Ctrl + Shift + F` | `Cmd + Shift + F` |
| Replace in files | `Ctrl + Shift + H` | `Cmd + Shift + H` |

🧠 Multi-cursor & Selection

| Action                 | Windows / Linux      | macOS                 |
| ---------------------- | -------------------- | --------------------- |
| Add cursor below       | `Ctrl + Shift + ↓`   | `Cmd + Shift + ↓`     |
| Add cursor above       | `Ctrl + Shift + ↑`   | `Cmd + Shift + ↑`     |
| Select all matching    | `Ctrl + Shift + L`   | `Cmd + Shift + L`     |
| Select next matching   | `Ctrl + D`           | `Cmd + D`             |
| Column (box) selection | `Shift + Alt + drag` | `Option + Cmd + drag` |

⚙️ Customize Shortcuts

Press Ctrl + K, then Ctrl + S (or Cmd + K Cmd + S on macOS) to open the Keyboard Shortcuts menu.
