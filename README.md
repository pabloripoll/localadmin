# Local Net Admin
This service runs on **systemctl** Debian 8+ / Ubuntu 16.04+ **(still in development)**

This script service is a batch of shortcuts to help on **LINUX OS** local machine or VPS server to speed up common actions to deploy, list or remove testing domains with much frequency.
In my case, accomplishing all the steps turned into an anoyed job thus a waiste of time and focus. So, that's why I took the time to implement something like this shortcuts support service.

My stack sorrounds a variaty of webapps projects with PHP, .NET, Java, NodeJS. So, this support service is developed for servers that primarly use NGINX listening on port 80 and reversed proxy for Apache2 on some PHP apps. \
In case of Dockerized projects, NodeJS *(w/PM2)*, .NET or JAVA...(in development)

## Installation
Create directory to place this bash as follows with path example:
```bash
$ mkdir /var/www/admin; sudo chown $USER:root /var/www/admin; cd /var/www/admin; 
```

Open the `install.sh` file to update settings if needed. By default the alias is `localnet`. Then, run the installation script
```bash
$ . install.sh
```

Now you can run the script commands inside.
```bash
$ localnet domains nginx
```

But before start, ** * read `config/settings.sh` to know if any variable or constant must be updated * **

# Commands
All examples use **localnet** as alias

**Listing registered domains:** \
List all domains registered by server plaform as **Nginx** or **Apache** *(shortcut for: apache2)*
```bash
$ localnet domains apache
```
Or is the sames as:
```bash
$ localnet domains:index apache
```

**Listing active domains:** \
List all domains registered and active running on localhost by server platform
```bash
$ localnet domains:active nginx
```

**Update server domains:** \
Once a domain is created or updated, run:
```bash
$ localnet domains:update nginx
```

**Check domain info:** \
Check domain status and configuration by server platform
```bash
$ localnet domain:create nginx example
```
Output domain example:
```bash
```

**Check domain info:** \
Check domain status and configuration by server platform
```bash
$ localnet domain apache example
```
Output domain example:
```bash
Domain: example.localhost has been created.
Domain: example.localhost is running!
Domain configuration:
<VirtualHost *:8080>
    ServerName example.localhost
    ServerAlias www.example.localhost
    
    DocumentRoot /var/www/apache/example/

    <Directory /var/www/apache/example/>
        Options -Indexes +FollowSymLinks -MultiViews
        AllowOverride All
        Require all granted
    </Directory>

    # Enable PHP-FPM adding the following block
    <FilesMatch \.php$>
        # 2.4.10+ can proxy to unix socket
        SetHandler "proxy:unix:/var/run/php/php8.1-fpm.sock|fcgi://localhost"
	# Else we can just use a tcp socket:
        # SetHandler "proxy:fcgi://127.0.0.1:9000"
    </FilesMatch> 

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```