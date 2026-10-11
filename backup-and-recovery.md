Backup and Recovery

In this part of my project, I wanted to make sure I could recover my Nextcloud data if something went wrong.

How I configured the backup

I created a Bash script on my Debian server to back up the Nextcloud database, application files and user data.

The script puts Nextcloud into maintenance mode before starting the backup. This prevents users from changing files during the process.

It then exports the MariaDB database using mariadb-dump and creates a compressed archive of the Nextcloud files and data directory.

After the backup is finished, the script disables maintenance mode.

I configured a systemd service and timer to run the script automatically every Sunday at 3 AM.

The script keeps the latest four successful backup folders and removes older ones.

How I tested the backup

After creating the script, I ran it manually to check whether it worked.

The first backup completed successfully, and Nextcloud returned to normal operation.

I checked the backup files and tested the compressed archive to make sure it could be read.

Database recovery test

I created a separate MariaDB database for testing.

I imported the SQL backup into this database and checked the number of tables.

The restored database contained 137 tables, which matched the original database.

After the test, I deleted the temporary database.

File recovery test

I also tested extracting the Nextcloud configuration file from the backup archive into a separate directory.

The extraction worked without changing the original configuration.

What is still missing

So far, I have tested the backup archive, database import and extraction of a configuration file.

I have not yet tested a complete Nextcloud installation restored from backup.

The backups are currently stored on the same device as the server. I plan to add a second backup location, such as an external drive or another computer, to protect the data if the server hardware fails.

What I learned

This part of the project helped me understand Bash scripting, Linux file permissions, MariaDB backups, systemd timers and the importance of testing backups.

I also learned that a successful backup does not automatically mean a complete recovery will work. Recovery needs to be tested separately.
