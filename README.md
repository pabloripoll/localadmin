# Domains Admin
This service runs on **systemctl** Debian 8+ / Ubuntu 16.04+ **(still in development)**

This script service is a batch of shortcuts to help on **LINUX OS** local machine or VPS server to speed up common actions to deploy, list or remove testing domains with much frequency.
In my case, accomplishing all the steps turned into an anoyed job thus a waiste of time and focus. So, that's why I took the time to implement something like this shortcuts support.

This support is developed for servers that primarly use NGINX listening on port 80. The **domain:create** wizard will ask for the basic configuration parameters to create a new server block but for practical usage, the edit will be manual. \
For PHP projects, will get PHP versions installed locally and depending on wich serve is choosed, will automatically reversed proxy. \
In the other hand, for Dockerized projects or directly served in other ports, like: NodeJS *(w/PM2)*, .NET or JAVA, it will create an server block for NGINX with reversed proxy to the desired port.

## Minimum requirements
Linux OS with Debian 8+ or Ubuntu 16+ \
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

But before start, **read `config/settings.sh` to know if any variable or constant must be updated**

# Commands

**· Listing registered domains:** \
List all domains registered by server plaform as **Nginx** or **Apache** *(shortcut for: apache2)*
```bash
$ localnet domains nginx
```
Or is the sames as:
```bash
$ localnet domains:index nginx
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

All `$ localnet domains:` scripts can be requested for Apache server as well.

**· Single domain action:** \
Default top level domain is *.localhost* for is not necessary to add it when is used on local machine
```bash
$ localnet domain nginx example
```
But if this program has been installed on a remote server, constant `TLD=""` on `config/settings.sh` must be empty to manage others top level domain
```bash
$ localnet domain nginx example.com
```

**· Check domain info:** \
To check out a domain existance and configuration
```bash
$ localnet domain nginx example
```
Output will prompt as follow example
```bash
server {
        listen 80;
        listen [::]:80;
        root /var/www/nginx/example;
        index index.php index.html;
        server_name example.localhost www.example.localhost;
        location / {
                try_files $uri $uri/ =404;
        }
        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/run/php/php8.1-fpm.sock;
        }
}
```
Or if domain is reversed proxy to another port as following example to Apache.
```bash
server {
        listen 80;
        listen [::]:80;
        server_name codesignart.localhost www.codesignart.localhost;
        location / {
                proxy_pass http://127.0.0.1:8080;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
        }
        location ~ /\.ht {
                deny all;
        }
}
```
So just on Apache reversed proxy domain existance and configuration look up can be requested changing server platform
```bash
$ localnet domain apache example
```
Output will prompt as follow example
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

    <FilesMatch \.php$>
        SetHandler "proxy:unix:/var/run/php/php8.1-fpm.sock|fcgi://localhost"
    </FilesMatch> 

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

**· Create domain:** \
Create domain by server platform
```bash
$ localnet domain:create nginx example
```
Output domain example:
```bash
```