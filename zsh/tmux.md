### Tmux Cheatsheet  

🧠 Basic Concepts
Session: Collection of windows.

Window: Like a tab; contains panes.

Pane: Subdivided terminal area.

🔑 Prefix Key
Default: Ctrl + b (denoted as C-b)

You can change it (e.g., to C-a) in .tmux.conf

🚀 Session Commands

| Action                     | Command/Shortcut                                                       |  
| -------------------------- | ---------------------------------------------------------------------- |  
| Start new session          | `tmux` or `tmux new -s <name>` or *`tmuxnew/tn`* or *`tnt/tns <name>`* |  
| List sessions              | `tmux ls` or *`tls`*                                                   |  
| Attach to session          | `tmux attach -t <name>` or *`ta`*(last session) or *`tat <name>`*      |  
| Kill session               | `tmux kill-session -t <name>` or *`tkt/tkill <name>`*                  |  
| Detach from session        | `Ctrl + B + d` or `td` or `tdetach`                                    | 
| Rename current session     | `tmux rename-session mysession` or `Ctrl + b $`                        |

🪟 Window Commands
| Action                     | Command/Shortcut                                                       |  
| -------------------------- | ---------------------------------------------------------------------- |  
| New window                 | `Ctrl + b c`                                                           |
| List windows               | `Ctrl + b w`                                                           |
| Rename window              | `Ctrl + b ,`                                                           |
| Switch window              | `Ctrl + b n / C-b p`                                                   |
| Select window by number    | `Ctrl + b <num>`                                                       |
| Kill current window        | `Ctrl + b &`                                                           |

🧱 Pane Commands
| Action                     | Command/Shortcut                                                       |  
| -------------------------- | ---------------------------------------------------------------------- |  
| Split pane horizontally    | `Ctrl + b "`                                                           |
| Split pane vertically      | `Ctrl + b %`                                                           |
| Switch panes               | `Ctrl + b o or arrow keys`                                             |
| Resize pane	               | `Ctrl + b then Hold Ctrl + Arrow`                                      |
| Kill pane	                 | `Ctrl + b x`                                                           |
| Convert pane to window     | `Ctrl + b !`                                                           |

📦 Copy & Paste (Copy Mode)
| Action                     | Command/Shortcut                                                       |  
| -------------------------- | ---------------------------------------------------------------------- |  
| Enter copy mode            | `Ctrl + b [`                                                           |
| Move cursor	               | `Arrow keys / hjkl`                                                    |
| Start selection            | `Space`                                             |
| Copy selection             | `Enter`                                             |
| Paste buffer               | `Ctrl + b ]`                                             |

