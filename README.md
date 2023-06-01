# Local Net Admin
This service runs on Debian/Ubuntu and it's itended for help on local linux machine or VPS server in which is installed server platforms Nginx and Apache2

## Configuration
open user bashrc
```bash
$ nano ~/.bashrc
```
At the end of the file add these following lines with the path where this app was located
```bash
## --- CUSTOM --- ###
alias localnet='/var/www/admin/main.sh'
```
Then update bashrc to perform
```bash
$ source ~/.bashrc
```