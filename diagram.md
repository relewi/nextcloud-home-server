
# Nextcloud Home Server Architecture

This diagram shows how my Nextcloud home server is connected and how the main services work together.

```mermaid
flowchart TB
    A["Family Devices<br/>Phones and Computers"]
    B["Nextcloud Domain<br/>cloud.example.com"]
    C["Cloudflare Tunnel"]

    I["Admin Computer"]
    J["Tailscale VPN"]
    K["SSH Access"]

    subgraph SERVER["Debian Linux Home Server"]
        direction TB
        L["Debian Operating System"]
        D["Nginx Web Server"]
        E["PHP-FPM"]
        F["Nextcloud"]
        G[("MariaDB Database")]
        H[("Redis Cache")]
        M[("File Storage")]
        N["Backup Script<br/>Bash and systemd"]

        L --- D
        D --> E
        E --> F
        F --> G
        F --> H
        F --> M
        N -.-> G
        N -.-> M
    end

    A --> B
    B --> C
    C --> D

    I --> J
    J --> K
    K --> L
```

Family members access Nextcloud through the domain and Cloudflare Tunnel.

Nginx handles web requests and passes PHP requests to PHP-FPM, which runs the Nextcloud application.

MariaDB stores application information, Redis provides caching, and file storage holds the uploaded files.

Server administration is done separately using Tailscale and SSH.

A Bash script creates backups of the database and Nextcloud files. The backup process is scheduled using systemd.
