# lighttpd2-alpine
Lighttpd2 on Alpine. Listens, by default, on port 8080 internally.

All tags: Lighttpd2 master from Github, Alpine Edge.

## Environment variables
### Runtime variables with default value
* VAR_LINUX_USER="www-user" (User running VAR_FINAL_COMMAND)
* VAR_CONFIG_DIR (/etc/lighttpd2): Directory containing configuration files.
* VAR_FINAL_COMMAND (lighttpd2 -c '\$VAR_CONFIG_DIR/angel.conf'): Command run by VAR_LINUX_USER.
* VAR_WWW_DIR (/var/www): Directory containing web content.
* VAR_HTTP_SOCKET_FILE (/run/http/lighttpd.sock): Unix socket to listen on.
* VAR_FASTCGI_SOCKET_FILE (/run/fastcgi/fastcgi.sock): Unix socket used for Fastcgi connections.
* VAR_angel1_config ('\$VAR_CONFIG_DIR/lighttpd.conf'): Path to lighttpd.conf.
* VAR_angel2_max_open_files (16384)
* VAR_angel3_copy_env ([ 'PATH' ])
* VAR_angel4_allow_listen ('unix:\$VAR_HTTP_SOCKET_FILE')
* VAR_angel5_allow_listen ('0.0.0.0/0:8080')
* VAR_angel6_allow_listen ('[::/0]:8080')
* VAR_angel7_allow_listen ('unix:\$VAR_FASTCGI_SOCKET_FILE')
* VAR_setup1_module_load ([ 'mod_fastcgi', 'mod_balance', 'mod_deflate' ]): Lighttpd2-modules to load.
* VAR_setup2_listen ('unix:\$VAR_HTTP_SOCKET_FILE')
* VAR_setup3_listen ('0.0.0.0:8080')
* VAR_setup4_listen ('[::]:8080')
* VAR_setup5_static__exclude_extensions ([ '.php', '.pl', '.fcgi', '~', '.inc' ])
* VAR_conf1_if (request.query=~'(map|MAP)=\w+((\.|/)?\w)*(&.+)?\$' {
                   balance.rr { fastcgi 'unix:\$VAR_FASTCGI_SOCKET_FILE'; };
                   if request.is_handled {
                      header.remove 'Content-Length';
                   }
                })
* VAR_conf2_else ({
                     include '\$VAR_CONFIG_DIR/mimetypes.conf';
                     docroot '\$VAR_WWW_DIR';
                     index [ 'index.php', 'index.html', 'index.htm', 'default.htm', 'index.lighttpd.html' ];
                     static;
                     if request.is_handled {
                        if response.header['Content-Type'] =~ '^(.*/javascript|text/.*)(;|\$)' {
                           deflate;
                        }
                     }
                  })

### Optional runtime variables
* VAR_angel&lt;id&gt;_&lt;param name&gt;: Parameter in angel.conf.
* VAR_setup&lt;id&gt;_&lt;param name&gt;: Setup parameter in lighttpd.conf.
* VAR_conf&lt;id&gt;_&lt;param name&gt;: Parameter in lighttpd.conf.

## Capabilities
Can drop all but SETPCAP, SETGID and SETUID.

