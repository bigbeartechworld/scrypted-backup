#!/bin/zsh

# SSH server details
ssh_server="user@host"

# File prefix
file_prefix="scrypted_backup_"

# Directory to store the backups
backup_directory="./backups"

# File name
file_name="$file_prefix$(date +%Y%m%d_%H%M%S).zip"

rsync -avz "$ssh_server:/root/.scrypted" ./
zip -r "$file_name" ./.scrypted

# Check if the directory exists
if [ -d "$backup_directory" ]; then
    echo "Destination directory exists. Moving file..."
else
    echo "Destination directory does not exist. Creating..."
    mkdir -p "$backup_directory"
fi

# Maximum time to wait in seconds
timeout_duration=300

# Move the file
# Start the timeout countdown
timeout $timeout_duration bash -c "
    # Loop until the file exists or timeout occurs
    while [ ! -f '$file_name' ]; do
        sleep 1
    done

    # File exists! Move it to the destination directory
    mv '$file_name' '$backup_directory'
"

# Remove the .scrypted directory
rm -rf ./.scrypted
