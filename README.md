# Nginx / Apache Domains Admin
This program runs on **systemctl** Debian 8+ / Ubuntu 16.04+ **(still in development)**

This program is a batch of shortcuts commands to help on **LINUX OS** local machine, VPS or cloud server to speed up common actions to deploy, list or remove domains with much frequency.
In my case as a web developer, accomplishing all the steps to manage several testing apps turned into an anoyed job thus a waiste of time and focus. So, that's why I took the time to implement something like this, for shortcuts support and no complex software installation.

This program is developed for servers that primarly use NGINX listening on port 80. The **domain:create** wizard will ask for the basic configuration parameters to create a new server block but for practical usage, the edit will be manual.

For PHP projects gets the installed versions on system by its directory name found on `/etc/php` and depending on wich serve the domain is being created will automatically reverse proxy. \
In the other hand, for other languages or Dockerized projects or directly served in other ports, like: NodeJS *(w/PM2)*, .NET or JAVA, it will create an server block for NGINX with reversed proxy to the desired port.

## Minimum requirements
Linux OS with Debian 8+ or Ubuntu 16+ \
NGINX on port:80 \

## Installation
By default the alias is the mnemotechnic `localnet` name and so all the following examples will use **localnet** as alias. But, if you want to use another alias, open `install.sh` file in main directory and change `ALIAS="otheralias"` constant.

Create the directory where this program is going to be placed. The following example will use:
```
$ mkdir /var/www/admin; sudo chown $USER:root /var/www/admin; cd /var/www/admin; 
```

Open the `install.sh` file to update settings if needed. Then, run the installation script
```
$ . install.sh
```

Now you can run the script commands inside. For e.g.:
```
$ localnet domains
```

But before start, **read `config/settings.sh` to know if any variable or constant must be updated**

# Commands

**· Listing registered domains:** \
List all domains registered by server plaform. 
```
$ localnet domains
```

That's the sames as:
```
$ localnet domains:index nginx
```

By default will list **Nginx** domains but it will list **Apache** *(shortcut for: apache2)* by specifying it
```
$ localnet domains apache
```

Command output will prompt something like the following example
```
Domains registered locally on NGINX server platform:
[jun 01 17:43] [active] my.site.localhost.conf
[may 03 22:53] [active] apitest.localhost.conf
[ene 11 2022X] [record] example.localhost.conf
```
Where `[record]` status is for domains that seved only on `site-available` but not on `site-enabled` directory. Thus, they cannot be visited by browsers.

Also there's a command to list both directories with their respective names `available` and `enabled`
```
$ localnet domains:available
```
```
$ localnet domains:available apache
```

**· Update server domains:** \
Once a domain is created or updated, server must be restarted. To do so, run
```
$ localnet domains:update
```
Above command can be requested for Apache server as well.
```
$ localnet domains:update apache
```

**· Search for registered domains:** \
Search for a domain on nginx server
```
$ localnet domains:like mydom
```
Result output
```
Domains registered on APACHE with name like: *mydom*
[active] mydomain.localhost.conf
[active] admin.mydomain.localhost.conf
[record] demo.mydomain.localhost.conf
[record] mydomain-old.localhost.conf
```
For searching on Apache server the server must be specified
```
$ localnet domains:like apache mydom
```
Result output
```
Domains registered on APACHE with name like: *mydom*
[active] mydomain.localhost.conf
[active] admin.mydomain.localhost.conf
[record] demo.mydomain.localhost.conf
[record] mydomain-old.localhost.conf
```
**· Single root domain actions:** \
Default top level domain is *.localhost* for is not necessary to add it when is used on local machine. For the following examples, *mydomain* will be used
```
$ localnet domain nginx mydomain
```
But if this program has been installed on a remote server, constant `TLD=""` on `config/settings.sh` must be set empty to manage full root domain
```
$ localnet domain nginx mydomain.com
```
**IMPORTANT!** **** Shouldn't be applied protocols **http:// https://**, neither subdomain **www.** ****

**· Check domain info:** \
To check out a domain existance and configuration
```
$ localnet domain nginx mydomain
```
Output will prompt as follows
```
Domain mydomain.localhost is recorded.
Domain mydomain.localhost is running!
Domain configuration:
server {
        listen 80;
        listen [::]:80;
        root /var/www/nginx/mydomain;
        index index.php index.html;
        server_name mydomain.localhost www.mydomain.localhost;
        location / {
                try_files $uri $uri/ =404;
        }
        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/run/php/php8.1-fpm.sock;
        }
}
```
For domains registered on Apache platform it can be seen its configuration file too
```
$ localnet domain apache mydomain
```
Output will be as follows
```
Domain: mydomain.localhost is recorded.
Domain: mydomain.localhost is running!
Domain configuration:
<VirtualHost *:8080>
    ServerName mydomain.localhost
    ServerAlias www.mydomain.localhost
    
    DocumentRoot /var/www/apache/mydomain/

    <Directory /var/www/apache/mydomain/>
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

**· Check domain status:** \
To check out a domain existance and configuration
```
$ localnet domain:status nginx mydomain
```
Output will prompt as follows on a laravel app example
```
Domain mydomain.localhost set on NGINX platform status:
HTTP/1.1 200 OK
Server: nginx/1.18.0 (Ubuntu)
Date: Mon, 05 Jun 2023 12:14:35 GMT
Content-Type: text/html; charset=UTF-8
Connection: keep-alive
Cache-Control: private, must-revalidate
pragma: no-cache
expires: -1
Set-Cookie: XSRF-TOKEN=eyJpdiI6InhUcDR4eEtwYmRFcHVvUDJob0pROEE9PSIsInZhbHVlIjoiMjM4VkpIVkYzSG1sVmUzUlhwRWNUVkd4Y1pkL0pDVnpqcHlnYkQwY21HTHZsVmJZTFd3RzhiL0t5VXJmNTRtWkxkaVlBN09HMERxSXNFR0lrQW85OWJVSzhZeG9ZZE5RRmlOTTBMOXJLc2lVK25LU3VzYllrNDBTWVpaUThvNlciLCJtYWMiOiIwM2I5YjY0MWY0Njk3NzdiNjQwYWJiOGZjMTA2ODM0Zjc3NmNiNzA4M2RiMzU1MTZhMjg5YTMxMjM0OWE2NTZkIiwidGFnIjoiIn0%3D; expires=Mon, 05-Jun-2023 14:14:35 GMT; Max-Age=7200; path=/; samesite=lax
Set-Cookie: mydomain_session=eyJpdiI6InVZQU1WUEhxSUhGUXp3TG1EL2ZkT0E9PSIsInZhbHVlIjoiWkMvL2FBcnc2VWwyQ3hYWHR0MFZsL2NsMU5ESGxBYWtHL3lXbUU0SytWR2NsS1lPZmpEM2paVEJxWlFmaDBZZGVRMTJPMzM1YmJwOEkrbjRkemlrK1l4aXRiS0JqbFNWRzhSL0diMHMvTXIxYlVaOFRXNjhhdHM1K1cxd2x2T2MiLCJtYWMiOiJhODg2YzkyODllMGE5OTNiNTEyOGFlYmI0ZWY0ZmJmMTc1NmEzOGRjOTNmMDdlNDgxOTM0Y2ExODQ4ZmE5ZjRlIiwidGFnIjoiIn0%3D; expires=Mon, 05-Jun-2023 14:14:35 GMT; Max-Age=7200; path=/; httponly; samesite=lax
```

**· Edit domain:** \
To edit a Nginx domain server block there is two commands to performe it
```
$ localnet domain mydomain edit
```
or
```
$ localnet domain:edit mydomain
```
It will open the server block to edit with nano
```
server {
        listen 80;
        listen [::]:80;
        root /var/www/nginx/mydomain;
        index index.php index.html;
        server_name mydomain.localhost www.mydomain.localhost;
        location / {
                try_files $uri $uri/ =404;
        }
        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/run/php/php8.1-fpm.sock;
        }
}
```
And for domains registered on Apache
```
$ localnet domain apache mydomain edit
```
or
```
$ localnet domain:edit apache mydomain
```

**· Create domain:** \
Create domain by server platform. To cancel process press <CTRL> + <C> keys.
```
$ localnet domain:create nginx mydomain
```
The project directory in which the domain will match can be pre defined with common path set on `setting.sh` file \
*("??" sets autocompleted default answer on empty value)* \
Once completed the domain creator wizard, just continue pressing **y** or cancel using **n** \
Nginx PHP output example:
```
Complete parameters followed by pressing <enter> key to set mydomain.localhost on NGINX server:
Enter (y or n) if domain will use SSL ?? n: 
Enter the language will be applied from between options [php|nodejs|dotnet|java|pyton|c++|go]: php
Enter index file ?? index.php: 
Enter the PHP version will be applied from options [8.1|7.4]: 8.1
Enter the directory in which the domain will match from /var/www/nginx/:mydomain
*** check configuration values before proceeding: ***
DOMAIN: mydomain.localhost
SERVER: Nginx
SSL: false
LANGUAGE: php
VERSION: 8.1
INDEX: index.php index.html
DIRECTORY: /var/www/nginx/mydomain
Are all the parameters correct? [y/n]:
```
Apache PHP output example:
```
Complete parameters followed by pressing <enter> key to set mydomain.localhost on APACHE server:
Enter (y or n) if domain will use SSL ?? n: 
Enter index file ?? index.php: 
Enter the PHP version will be applied from options [8.1|7.4]: 8.1
Enter the directory in which the domain will match from /var/www/apache/:mydomain
*** check configuration values before proceeding: ***
DOMAIN: mydomain.localhost
SERVER: Nginx
Proxy: APACHE on port :8080
SSL: false
LANGUAGE: php
VERSION: 8.1
INDEX: index.php index.html
DIRECTORY: /var/www/apache/mydomain
Are all the parameters correct? [y/n]:
```
Nginx other language output example:
```
Complete parameters followed by pressing <enter> key to set mydomain.localhost on NGINX server:
Enter (y or n) if domain will use SSL ?? n: 
Enter the language will be applied from between options [php|nodejs|dotnet|java|pyton|c++|go]: go
Enter index file ?? index.html: main.go
To prevent a listener overlap, you`d have to be sure the port to use: $ sudo ss -tulwn | grep LISTEN
Enter the port will be reversed proxy to: 5000
Enter the directory in which the domain will match from /var/www/golang/:mydomain
*** check configuration values before proceeding: ***
DOMAIN: mydomain.localhost
SERVER: Nginx
Proxy: GO on port :5000
SSL: false
LANGUAGE: go
INDEX: main.go
DIRECTORY: /var/www/golang/mydomain
Are all the parameters correct? [y/n]:
```

**· Put up domain:** \
To put a domain up online in Nginx
```
$ localnet domain:up mydomain
```
Output may ask your sudo user password
```
Domain mydomain.localhost access through NGINX platform will be put up online.
Are you sure to proceed? [y/n]: y
Domain mydomain.localhost has been put up online in NGINX platform.
NGINX sites has been updated!
```

And for putting a domain up online in Apache
```
$ localnet domain:up apache mydomain
```
Output
```
Domain mydomain.localhost access through APACHE platform will be put up online.
Are you sure to proceed? [y/n]: y
Domain mydomain.localhost has been put up online in APACHE platform.
APACHE sites has been updated!
Domain mydomain.localhost has been put up online in NGINX platform.
NGINX sites has been updated!
```

**· Put down domain:** \
To put a domain down offline in Nginx
```
$ localnet domain:down mydomain
```
Output may ask your sudo user password
```
Domain mydomain.localhost access through APACHE platform will be put down offline.
Are you sure to proceed? [y/n]: y
[sudo] password for "user":
Domain mydomain.localhost has been put down offline in APACHE platform.
APACHE sites has been updated!
Domain mydomain.localhost has been put down offline in NGINX platform.
NGINX sites has been updated!
```

And for puttin a domain down offline in Apache
```
$ localnet domain:down apache mydomain
```
Output
```
Domain mydomain.localhost access through APACHE platform will be put down offline.
Are you sure to proceed? [y/n]: y
[sudo] password for "user":
Domain mydomain.localhost has been put down offline in APACHE platform.
APACHE sites has been updated!
Domain mydomain.localhost has been put down offline in NGINX platform.
NGINX sites has been updated!
```

**· Remove domain from register:** \
To remove of a domain registere on Nginx
```
$ localnet domain:remove mydomain
```
Output
```

```

And for Apache
```
$ localnet domain:remove apache mydomain
```
Output
```

```