# Domains Admin
This service runs on **systemctl** Debian 8+ / Ubuntu 16.04+ **(still in development)**

This script service is a batch of shortcuts to help on **LINUX OS** local machine or VPS server to speed up common actions to deploy, list or remove testing domains with much frequency.
In my case, accomplishing all the steps turned into an anoyed job thus a waiste of time and focus. So, that's why I took the time to implement something like this shortcuts support.

This support is developed for servers that primarly use NGINX listening on port 80. The **domain:create** wizard will ask for the basic configuration parameters to create a new server block but for practical usage, the edit will be manual. \
For PHP projects, will get PHP versions installed locally and depending on wich serve is choosed, will automatically reversed proxy. \
In the other hand, for Dockerized projects or directly served in other ports, like: NodeJS *(w/PM2)*, .NET or JAVA, it will create an server block for NGINX with reversed proxy to the desired port.

## Minimum requirements
NGINX on port:80 \
Apache2 \
PHP FPM

## Installation
By default the alias is the mnemotechnic `localnet` name. So, all following examples will use **localnet** as alias. If you want to use another alias, open `install.sh` file in main directory and change `ALIAS="localnet"` constant.

Create directory where this script service is going to be placed. The following example will use:
```bash
$ mkdir /var/www/admin; sudo chown $USER:root /var/www/admin; cd /var/www/admin; 
```

Open the `install.sh` file to update settings if needed. Then, run the installation script
```bash
$ . install.sh
```

Now you can run the script commands inside. For e.g.:
```bash
$ localnet domains nginx
```

But before start, ** * read `config/settings.sh` to know if any variable or constant must be updated * **

# Commands

**· Listing registered domains:** \
List all domains registered by server plaform as **Nginx** or **Apache** *(shortcut for: apache2)*
```bash
$ localnet domains apache
```
Or is the sames as:
```bash
$ localnet domains:index apache
```

**· Listing active domains:** \
List all domains registered and active running on localhost by server platform
```bash
$ localnet domains:active nginx
```

**· Update server domains:** \
Once a domain is created or updated, run:
```bash
$ localnet domains:update nginx
```

**· Create domain:** \
Create domain by server platform
```bash
$ localnet domain:create nginx example
```
Output domain example:
```bash
```

**· Check domain info:** \
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