# Scrypted Backup

Scrypted Backup is a tool for backing up and restoring Scrypted data.

## Walkthrough Video

[![Alt text](https://img.youtube.com/vi/35FY2gYL-O0/0.jpg)](https://www.youtube.com/watch?v=35FY2gYL-O0)

## Using Proxmox

So if you're using Proxmox you need to open up ssh and run the following commands:

1. Setup a root password

```bash
sudo passwd root
```

2. Enable ssh

```bash
nano /etc/ssh/sshd_config
```

3. Change the following line:

```bash
PermitRootLogin without-password
```

to

```bash
PermitRootLogin yes
```

4. Restart ssh

```bash
systemctl restart sshd
```

# Install Scrypted Backup

1. Install git on your OS

2. Clone the repo

```bash
git clone https://github.com/bigbeartechworld/scrypted-backup.git scrypted-backup
```

3. Change directory

```bash
cd scrypted-backup
```

4. Open up the backup.sh file and change the following variables:

```bash
ssh_server="user@host"
```

to your credentials

5. Open up the restore.sh file and change the following variables:

```bash
ssh_server="user@host"
```

to your credentials

6. Run the backup script

```bash
sh ./backup.sh
```

7. Run the restore script

```bash
sh ./restore.sh
```

## Need Support or Have Ideas?

Join the BigBearCommunity [Discord](https://bit.ly/bbtw-community) and let us know what you think!
