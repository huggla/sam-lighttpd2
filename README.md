# sam-lighttpd2
Lighttpd2 from Github master, running on Alpine. Configuration is set by given VAR_angel, VAR_setup and VAR_mode variables. Add, edit och unset runtime configuration variables as you see fit (by default set to fcgi-mode and listen on port 8080 internally).

## Environment variables
### Runtime variables with default value
* VAR_LINUX_USER="www-user" (User running VAR_FINAL_COMMAND)
* VAR_CONFIG_DIR="/etc/lighttpd2" (Directory containing configuration files)
* VAR_FINAL_COMMAND="lighttpd2 -c '\$VAR_CONFIG_DIR/angel.conf'" (Command run by VAR_LINUX_USER)
* VAR_OPERATION_MODE="fcgi" (Which mode-configuration to use)
* VAR_WWW_DIR="/var/www" (Directory containing web content in normal mode)
* VAR_HTTP_SOCKET_FILE="/run/http/lighttpd.sock" (Can be used in VAR_angelx_allow_listen + VAR_setupx_listen)
* VAR_FASTCGI_SOCKET_FILE="/run/fastcgi/fastcgi.sock" (Unix socket used for Fastcgi connections. Can be used in VAR_angelx_allow_listen in fcgi mode)
* VAR_angel1_config="'\$VAR_CONFIG_DIR/lighttpd.conf'" (Path to lighttpd.conf)
* VAR_angel2_max_open_files="1024"
* VAR_angel3_copy_env="[ 'PATH' ]"
* VAR_angel4_max_core_file_size="0"
* VAR_angel5_allow_listen="'0.0.0.0/0:8080'"
* VAR_angel6_allow_listen="'unix:\$VAR_FASTCGI_SOCKET_FILE'"
* VAR_setup1_module_load="[ 'mod_fastcgi' ]" (Lighttpd2-modules to load. Please set to "[ 'mod_deflate' ]" if using default normal mode)
* VAR_setup2_listen="'0.0.0.0:8080'"
* VAR_setup3_workers="1"
* VAR_setup4_io__timeout="120"
* VAR_setup5_stat_cache__ttl="10"
* VAR_setup6_tasklet_pool__threads="0"
* VAR_mode_fcgi=\
"     buffer_request_body false;\n"\
"     strict.post_content_length false;\n"\
"     if req.header['X-Forwarded-Proto'] =^ 'http' and req.header['X-Forwarded-Port'] =~ '[0-9]+' {\n"\
"       env.set 'REQUEST_URI' => '%{req.header[X-Forwarded-Proto]}://%{req.host}:%{req.header[X-Forwarded-Port]}%{req.raw_path}';\n"\
"     }\n"\
"     fastcgi 'unix:\$VAR_FASTCGI_SOCKET_FILE';\n"\
"     if request.is_handled { header.remove 'Content-Length'; }" \
* VAR_mode_normal=\
"      include '\$VAR_CONFIG_DIR/mimetypes.conf';\n"\
"      docroot '\$VAR_WWW_DIR';\n"\
"      index [ 'index.php', 'index.html', 'index.htm', 'default.htm', 'index.lighttpd.html' ];\n"\
"      static;\n"\
"      if request.is_handled {\n"\
"         if response.header['Content-Type'] =~ '^(.*/javascript|text/.*)(;|\$)' {\n"\
"            deflate;\n"\
"         }\\n"\
"      }"

### Format of runtime configuration variables
* VAR_ADD_MIMETYPES: Comma-separated list of additional mimetypes (f ex. ".PDF" => "application/pdf").
* VAR_angel&lt;id&gt;_&lt;param name&gt;: Parameter in angel.conf.
* VAR_setup&lt;id&gt;_&lt;param name&gt;: Setup parameter in lighttpd.conf.
* Dot (.) is representated as double underscore (\_\_) in variable names.
* Id-numbers defines the configuration order.

## Capabilities
Can drop all but SETPCAP, SETGID and SETUID.

