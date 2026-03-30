# ~/.dotfiles/zsh/completions.zsh
# Zsh module providing command completions
# Managed by: ~/.dotfiles/zsh/zshrc
# Author: Simge Ekiz
# License: MIT

# Use modern completion system
autoload -Uz compinit

# Cache dir (portable pattern)
: "${ZSH_CACHE_DIR:=$HOME/.cache/zsh}"
mkdir -p "$ZSH_CACHE_DIR"

# Set dump file inside cache dir
ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"

# Caching autocompletion
if [[ -n $ZSH_COMPDUMP(#qN.mh+24) ]]; then
  # Tab-completion for options, Git branches, etc.
  compinit -d "$ZSH_COMPDUMP" -i
else
  # echo "Creating completion dump file..."
  compinit -C -d "$ZSH_COMPDUMP" -i
fi

# Zsh completion uses a 5-part context system:
# :completion:function:completer:command:argument:tag

# Ensures that the completion menu is always shown
zstyle ':completion:*' menu select

# set completion colors to be the same as `ls`, if available
if [[ -n $LS_COLORS ]]; then
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
elif [[ -n $LSCOLORS ]]; then
  zstyle ':completion:*' list-colors "${(s.:.)LSCOLORS}"
fi
# # Group results by category
# zstyle ':completion:*' group-name ''

# Make completion case-insensitive
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# case insensitive (all), partial-word and substring completion
if [[ "$CASE_SENSITIVE" = true ]]; then
  zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'
elif [[ "$HYPHEN_INSENSITIVE" = true ]]; then
  zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'
else
  zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
fi
unset CASE_SENSITIVE HYPHEN_INSENSITIVE

# Complete . and .. special directories
zstyle ':completion:*' special-dirs true

#  Kill command coloring (adds color to the process list shown during 
# tab-completion for the kill command.)
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# Enable approximate matches for completion # _approximate
zstyle ':completion:*' completer _expand _complete _ignored _approximate

# Directory navigation priority (disable named-directories autocompletion)
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR"

## Visual tweaks
# Add trailing slash for symlinked dirs
zstyle ':completion:*' mark-symlinked-directories true
# Limit large completion lists
zstyle ':completion:*' list-max 200

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'

# Show ignored if explicitly requested
zstyle '*' single-ignored show


