Nextcloud Home Server

About this project

I set up my own Nextcloud server at home to store files and share them with my family. I wanted to learn more about Linux servers and how different services work together.

For this project, I used a small Lenovo device and installed Debian Linux without a graphical desktop. I manage the server remotely from my Windows computer using SSH.

Software and technologies

Debian Linux: The operating system running on my server.

Nextcloud: The application I use for storing and sharing files.

Nginx: The web server that handles requests to Nextcloud.

PHP-FPM: Runs the PHP code used by Nextcloud.

MariaDB: Stores the application data, user information and settings.

Redis: Used for caching and file locking.

SSH: Allows me to manage the Linux server remotely.

Tailscale: Gives me private remote access to the server.

Cloudflare Tunnel: Allows access to Nextcloud from outside my home network without opening incoming ports on my router.

systemd: Manages Linux services and runs scheduled tasks.

What I did

I started by installing Debian Linux and setting up remote access with SSH.

After that, I installed and configured the software needed for Nextcloud, including Nginx, PHP, MariaDB and Redis.

I configured Cloudflare Tunnel so my family can access Nextcloud from their devices, even when they are not connected to our home Wi-Fi.

I also created separate user accounts and configured a shared folder for family files.

Another part of the project was setting up email notifications and improving the Nextcloud configuration.

Backup and recovery

I wrote a Bash script to back up the Nextcloud files and MariaDB database.

The script runs automatically every Sunday at 3 AM using a systemd timer. It keeps the latest four successful backups.

I tested the backup by checking the archive and restoring the database into a separate test database. I also tested extracting a configuration file from the backup.

A complete server recovery test is still planned.

What I learned

This project helped me understand how Linux services work together.

I also gained practical experience with SSH, file permissions, web servers, databases, networking and automated backups.

Some parts took more time than expected, especially checking the configuration and making sure the backup worked correctly.

Next steps

I want to test the server with everyday family use, create an additional backup outside the server and improve my Linux administration skills.

The server is currently running, and I will continue working on it as I learn more.
