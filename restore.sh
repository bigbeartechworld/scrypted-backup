#!/bin/zsh

# Local directory where the file is located
backup_directory="./backups"

# Remote directory where the file will be copied
remote_directory="/root"

# File to store the SSH IP address
ip_file="ssh_ip.txt"

# File to store the SSH password
password_file="ssh_password.txt"

# Check if the ssh ip file exists
if [ -f "$ip_file" ]; then
    # Read the password from the file
    ip_address=$(cat "$ip_file")
else
    # Prompt for SSH ip
    read -s -p "Enter SSH IP: " ip_address
    echo

    # Save the ip to the file
    echo "$ip_address" > "$ip_file"
fi

# SSH server details
ssh_server="root@$ip_address"

# Check if the password file exists
if [ -f "$password_file" ]; then
    # Read the password from the file
    ssh_password=$(cat "$password_file")
else
    # Prompt for SSH password
    read -s -p "Enter SSH password: " ssh_password
    echo

    # Save the password to the file
    echo "$ssh_password" > "$password_file"
fi

# Delete .scrypted-restore directory if it exists
rm -rf ./.scrypted-restore

# Prompt user to select a backup file
echo "Available backup files:"
backup_files=($(ls -t "$backup_directory"/*.zip))

# Check if any backup files exist
if [ ${#backup_files[@]} -eq 0 ]; then
    echo "No backup files found in the directory."
    exit 1
fi

PS3="Enter the number of the backup file you want to select: "
select backup_file in "${backup_files[@]}"; do
    if [ -n "$backup_file" ]; then
        echo "You selected: $backup_file"
        break
    else
        echo "Invalid selection. Please try again."
    fi
done

backup_file_name=$(basename "$backup_file")

# Copy file from backups to current directory
cp "$backup_file" ./

# # Unzip the file
unzip "$backup_file" -d "./.scrypted-restore"

# Delete data directory if it exists from ssh
sshpass -p "$ssh_password" ssh "$ssh_server" "rm -rf $remote_directory/.scrypted"

# # Rsync the latest file to the SSH server with password authentication
sshpass -p "$ssh_password" rsync -avz "./.scrypted-restore/.scrypted/" "$ssh_server:$remote_directory/.scrypted"

# # Set permissions and remove node_modules and reinstall
sshpass -p "$ssh_password" ssh "$ssh_server" "chown -R root:root $remote_directory/.scrypted && cd $remote_directory/.scrypted && rm -rf node_modules && npm install && service scrypted restart"

# # Remove the .scrypted-restore directory
rm -rf ./.scrypted-restore

# # Remove the zip file
rm "$backup_file_name"
