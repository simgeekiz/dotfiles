# ~/.dotfiles/onedrive/onedrive_aliases.sh
# OneDrive sync aliases
# Managed by: ~/.dotfiles/onedrive/onedrive_aliases.sh
# Author: Simge Ekiz
# License: MIT

if command -v onedrive >/dev/null 2>&1; then
  # Teams / SharePoint sync
  alias teams-sync='onedrive --confdir="$HOME/.config/OneDriveTeamsMacroscope" --sync'
  alias teams-monitor='onedrive --confdir="$HOME/.config/OneDriveTeamsMacroscope" --monitor'

  # Personal OneDrive sync
  alias odsync='onedrive --sync'
  alias onedrive-sync='onedrive --sync'
  alias onedrive-monitor='onedrive --monitor'
fi
