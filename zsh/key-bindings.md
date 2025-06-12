### Key Bindings

- bindkey -e = "Use Emacs-style keyboard shortcuts in the terminal."
It makes editing commands faster using keys like Ctrl + A, Ctrl + E, etc.

So when you're typing a command in the terminal, you can do things like:

    Shortcut	What it does
    ✍️ Cursor Movement
    - Ctrl + A	Move to start of line
    - Ctrl + E	Move to end of line
    - Alt + B	Move backward one word
    - Alt + F	Move forward one word
    - Ctrl + B	Move left (backward one char)
    - Ctrl + F	Move right (forward one char)
    ✂️ Deleting / Killing Text
    - Ctrl + D	Delete character under cursor
    - Ctrl + H	Delete character before cursor (like Backspace)
    - Alt + D	Delete word after cursor
    - Ctrl + W	Delete word before cursor
    - Ctrl + U	Delete from cursor to beginning of line
    - Ctrl + K	Delete from cursor to end of line
    📋 Clipboard-like Operations
    - Ctrl + Y	Paste the last killed text
    🔍 History Search
    - Ctrl + R	Reverse search through command history
    - Ctrl + S	Forward search (sometimes blocked by terminal, can be remapped)
    🔁 Undo
    - Ctrl + _	Undo last change

- Added Keybindings

  | Key             | Sequence | Action        |  
  | --------------- | -------- | ------------- |  
  | `Delete`        | `^[[3~`  | `delete-char` |  
  | `Ctrl + Delete` | `^[3;5~` | `delete-char` |  
  | `Home`          | `^[[H`   | `beginning-of-line` |  Ctrl + A
  | `End`           | `^[[F`   | `end-of-line`       |  Ctrl + E
  | `Alt + ←`          | `^[[1;3D`   | `backward-word` |  `Alt + B`   
  | `Alt + →`           | `^[[1;3C`   | `forward-word` |  `Alt + F`   
  | `Ctrl + ←`          | `^[[1;5D`   | `beginning-of-line` |  
  | `Ctrl + →`           | `^[[1;5C`   | `end-of-line`      |  
  | `Ctrl + X Ctrl + U`  | `^X^U`   | `kill-whole-line`      |  


  - This command lists all available Zsh keymaps — not individual keybindings, but collections of keybindings.
  ```  
    $ bindkey -l 
  ```
 
  - You can verify the keys are bound:
  ```  
    $ bindkey | grep 'up-line-or-beginning-search'

      "^[[A" up-line-or-beginning-search
      "^[OA" up-line-or-beginning-search
  ```
  - This command queries what keybinding (if any) is currently assigned to Ctrl + U.  
    It simply prints the widget currently associated with Ctrl + U.
  ```  
    $ bindkey '^U'   

      "^U" backward-kill-line
  ```  


  - Press ↑ and ↓ to search history commands starting with what you've typed.   
    Type part of a past command, like echo.  
    Press ↑ and ↓ — it should search just commands that start with echo.  
   