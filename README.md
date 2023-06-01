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

### sources:
https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux \
https://stackoverflow.com/questions/10586153/how-to-split-a-string-into-an-array-in-bash \
https://stackoverflow.com/questions/20033648/how-to-run-mysql-command-on-bash \
https://stackoverflow.com/questions/3231804/in-bash-how-to-add-are-you-sure-y-n-to-any-command-or-alias \
https://www.baeldung.com/linux/use-command-line-arguments-in-bash-script \
https://www.baeldung.com/linux/return-vs-exit \
https://www.redhat.com/sysadmin/using-bash-automation \
https://serverfault.com/questions/937281/parsing-command-output-in-bash-script