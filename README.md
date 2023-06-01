# Local Net Admin
This service runs on Debian 8+ / Ubuntu 16.04+ **(still in development)**

The intention of this script service is for helping on local machine or VPS server *(with LINUX OS)* to speed up common actions to deploy, list or remove testing domains with much frequency.
In my case, accomplished all the steps turned into an anoyed job and waiste of time and focus. And that's why I took the time to implement something like this script service.

My stack sorrounds webapps woth PHP or NodeJS, so this script service is developed for machines with servers platforms installed like Nginx, Apache2 and NodeJS *(w/PM2)*.

## Configuration
Open user bashrc
```bash
$ nano ~/.bashrc
```
At the end of the file add these following lines with the path where this service script was located
```bash
## --- CUSTOM --- ###
alias localnet='/var/www/admin/main.sh'
```
Then update bashrc
```bash
$ source ~/.bashrc
```
