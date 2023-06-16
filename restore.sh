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

# Check if the directory exists on the remote server
ssh "$ssh_server" "[ -d \"$remote_directory/.scrypted-restore\" ]"

# If the directory doesn't exist, create it on the remote server
if [ $? -ne 0 ]; then
    echo "Creating .scrypted-restore directory on the remote server..."
    ssh "$ssh_server" "mkdir \"$remote_directory/.scrypted-restore\""
else
    echo ".scrypted-restore directory already exists on the remote server."
fi

# Rsync the latest file to the SSH server with password authentication
rsync -avz "./.scrypted-restore/.scrypted/" "$ssh_server:$remote_directory/.scrypted"

# Remove the .scrypted-restore directory
rm -rf ./.scrypted-restore

# Remove the zip file
rm "$latest_file"
