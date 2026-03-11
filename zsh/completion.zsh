# Use modern completion system
autoload -Uz compinit

# Caching autocompletion
# if [[ -f ~/.zcompdump && ~/.zcompdump -nt ~/.zshrc ]]; then
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit -i # Tab-completion for options, Git branches, etc.
else
  echo "Creating completion dump file..."
  compinit -C -i
fi

# Zsh completion uses a 5-part context system:
# :completion:function:completer:command:argument:tag

# Ensures that the completion menu is always shown
zstyle ':completion:*' menu select

# set completion colors to be the same as `ls`, if available
[[ -z "$LS_COLORS" ]] || zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# # Group results by category
# zstyle ':completion:*' group-name ''

# Make completion case-insensitive
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# case insensitive (all), partial-word and substring completion
if [[ "$CASE_SENSITIVE" = true ]]; then
  zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'
else
  if [[ "$HYPHEN_INSENSITIVE" = true ]]; then
    zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'
  else
    zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
  fi
fi
unset CASE_SENSITIVE HYPHEN_INSENSITIVE

# Complete . and .. special directories
zstyle ':completion:*' special-dirs true

# adds color to the process list shown during 
# tab-completion for the kill command.
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# Enable approximate matches for completion
zstyle ':completion:::::' completer _expand _complete _ignored _approximate

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path $ZSH_CACHE_DIR

# Add trailing slash for symlinked dirs
zstyle ':completion:*' mark-symlinked-directories true

# Limit large completion lists
zstyle ':completion:*' completions 200

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

# ... unless we really want to.
zstyle '*' single-ignored show


