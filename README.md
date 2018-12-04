**Note! I use Docker latest tag for development, which means that it isn't allways working. Date tags are stable.**

# lighttpd2-alpine
Lighttpd2 on Alpine. Listens, by default, on port 8080 internally.

## Environment variables
### pre-set runtime variables
* VAR_LINUX_USER (www-user)
* VAR_CONFIG_DIR (/etc/lighttpd2)
* VAR_FINAL_COMMAND

### Optional runtime variables
* VAR_setup&lt;id&gt;_&lt;config name&gt;: Setup config in lighttpd.conf.

## Capabilities
Can drop all but SETPCAP, SETGID and SETUID.

