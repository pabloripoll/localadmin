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