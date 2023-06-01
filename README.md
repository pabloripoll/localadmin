# Local Net Admin
This service runs on Debian 8+ / Ubuntu 16.04+ **(still in development)**

This bash script service is for helping on local machine or VPS server *(with LINUX OS)* to speed up common actions to deploy, list or remove testing domains with much frequency.
In my case, accomplishing all the steps turned into an anoyed job and waiste of time and focus. So, that's why I took the time to implement something like this local support service.

My stack sorrounds a variaty of webapps projects with PHP, .NET, Java, NodeJS. So, this support service is developed for machines with serves port 80 with NGINX, proxing Apache2, NodeJS *(w/PM2)*.

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

**Listing registered domains:** \
List all domains registered on server plaform like **Nginx** or **Apache** *(shortcut for: apache2)*
```bash
$ localnet domains apache
```
Or is the sames as:
```bash
$ localnet domains:index apache
```

**Listing active domains:** \
List all domains registered and active to visit on localhost by server
```bash
$ localnet domains:active apache
```

**Update server domains:** \
List all domains registered and active to visit on localhost by server
```bash
$ localnet domains:active apache
```

**Check domain info:** \
List all domains registered and active to visit on localhost by server
```bash
$ localnet domain example
```
Output on registered domain:
```bash
Domain: example.localhost is running on APACHE reversed proxy by NGINX
```
Output if domain is not registered in any server platform
```bash
Domain: .localhost has not been activated.
To activate this domain run: $ localnet domain:create
```