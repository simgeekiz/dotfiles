# Install onedrive

```
sudo apt update
sudo apt install onedrive

# Then start the initial setup:
onedrive
```

- Sign in through the browser link it shows. Your OneDrive files will normally be synced to:

```
~/OneDrive
```

- Then test a sync

```
onedrive --synchronize --verbose
```

- For ongoing automatic syncing after successful setup:

```
- After the first successfull setup, enable the user service:
systemctl --user enable --now onedrive

```

- Check whether it is running:

```
systemctl --user status onedrive
```

- Keep your normal system updates current through Update Manager, or run:

```
sudo apt update
sudo apt upgrade

```

- OR, To sync manually whenever you choose:

```
onedrive --synchronize
```

#### Useful configuration

The configuration file is usually here:

```
~/.config/onedrive/config
Create it first if needed:

mkdir -p ~/.config/onedrive
cp /usr/share/doc/onedrive/config ~/.config/onedrive/config

# For example, you can choose to sync only selected folders, rather than your whole OneDrive:

sync_dir = "~/OneDrive"

# Then create a file named:
~/.config/onedrive/sync_list

Add folders such as:
Documents
Uni
```

### Is UvA suggesting one over another?

UvA recommends using the open-source OneDrive Free Client (Fork), which is actively maintained by "abraunegg" on GitHub
https://staff.fnwi.uva.nl/a.bon/zs/OneDrive-Linux-EN.pdf

---

## Adding a Teams shared folder

To synchronize Microsoft Teams channel files or SharePoint shared folders

- 1. Find the Drive ID for the Teams or SharePoint Library

```
onedrive --get-sharepoint-drive-id "Name of your Team"
```

- 2. Configure a Separate Sync Directory and Config for Each Library
     Each library (Teams/SharePoint/Shared) should use a separate configuration directory, local folder, and database. For example, create a directory for the specific Teams sync configuration:

```
mkdir -p ~/OneDriveTeams/your-team-name
mkdir ~/.config/OneDriveTeams<team_name>
nano ~/.config/OneDriveTeams<team_name>/config
```

- 3. Edit the config file to set sync_dir to the desired local path for that Team and Set Up the Drive ID in Config

```
# In the configuration file for this sync directory, add or update:
sync_dir = "~/OneDriveTeams/<team_name>"
# Your drive_id from step 2
drive_id = "<copied-Drive-ID-here>"
```

- 4. Authenticate and Perform First Sync

Run the client pointing to your new config directory:

```
onedrive --confdir="~/.config/OneDriveTeams<team_name>" --synchronize
 # !!!You may need to run through the authentication flow the first time.
```

6. Ongoing Sync
   For continuous monitoring:

```
onedrive --confdir="~/.config/OneDriveTeams<team_name>" --monitor
# Or set this up as a user service using systemd, pointing to the right config directory.
```

---

##### I have already installed and onedrive in Linux and it automaticaly sysncs however it creates safebasckups and I do not want that I am the only one using and it stills creates conflicts and I do not want to deal with it becase it creates multiple duplicates of a file.

I am going to stop the service and I am going to use `onedrive-sync` alias to sync my changes

```
# Show whether the user‑service is active, inactive, or failed
systemctl --user status onedrive.service

# Stop it for the current session
systemctl --user stop onedrive.service

# Disable it so it never starts automatically at login
systemctl --user disable onedrive.service
```

## Sync on demand from the command line

Whenever you want to push or pull changes, run the client manually:

```
onedrive --sync         # one‑time full sync
# or, if you prefer a faster incremental run:
onedrive --monitor --single-sync   # runs until it finishes one cycle and then exits

```
