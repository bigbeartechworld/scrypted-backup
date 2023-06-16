#!/bin/zsh

# Local directory where the file is located
local_directory="./backups"

# SSH server details
ssh_server="user@host"

# Remote directory where the file will be copied
remote_directory="/root"

# Delete .scrypted-restore directory if it exists
rm -rf ./.scrypted-restore

# Get the latest file name
latest_file=$(ls -t "$local_directory" | head -n 1)

# Copy file from backups to current directory
cp "$local_directory/$latest_file" ./

# Unzip the file
unzip "$latest_file" -d "./.scrypted-restore"

# Rsync the latest file to the SSH server with password authentication
rsync -avz "./.scrypted-restore/.scrypted/" "$ssh_server:$remote_directory/.scrypted"

# Set permissions and remove node_modules and reinstall
ssh "$ssh_server" "chown -R root:root $remote_directory/.scrypted && cd $remote_directory/.scrypted && rm -rf node_modules && npm install && service scrypted restart"

# Remove the .scrypted-restore directory
rm -rf ./.scrypted-restore

# Remove the zip file
rm "$latest_file"
