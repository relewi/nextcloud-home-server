Home Server Architecture

This file explains how the different parts of my Nextcloud home server work together.

Server

I use a small Lenovo computer running Debian Linux. The server runs without a graphical desktop, and I manage it remotely from my Windows PC.

How devices connect

My family can access Nextcloud from their phones or computers using a web browser or the Nextcloud app.

For external access, I use Cloudflare Tunnel. It connects my home server to Cloudflare without requiring incoming ports to be opened on my router.

For server administration, I use SSH. I also use Tailscale to access the server through a private network when I am away from home.

How Nextcloud works

When someone opens Nextcloud, the request goes through Nginx.

Nginx passes the PHP requests to PHP-FPM, which runs the Nextcloud application.

Nextcloud uses MariaDB to store information such as user accounts, settings and file metadata.

The actual uploaded files are stored separately on the server.

Redis is used for caching and file locking.

Backup

I use a Bash script to back up the Nextcloud files and database.

A systemd timer runs the backup automatically every Sunday at 3 AM.

The script keeps the latest four successful backups.

I have tested the backup archive, database import and extraction of configuration files. A full server recovery test is still planned.

Security

The server is managed through SSH and Tailscale.

External Nextcloud access is provided through Cloudflare Tunnel.

Each family member has a separate Nextcloud account.

This repository does not contain real IP addresses, passwords, private keys or personal files.
