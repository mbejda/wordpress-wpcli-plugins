# Ultimate Docker Image for WordPress

* Nginx, 
* MySQL Server
* SSH Server 
* FTP Server 
* WP-CLI

## Environmental Variables

* SITEURL "127.0.0.1"
* PLUGINS ""
* WPMEMORY "9M"
* WPMEMORYMAX "10M"
* WPADMIN "admin"
* WPPASSWORD "password"
* WPEMAIL "admin@admin.com"
* WPTITLE "Title"

By default, the image installs WordPress Version 4.1. This can be changed by having the WP-CLI install a fresh copy directly from WordPress by removing the 'ADD WordPress' command and removing the WP-CLI hash from the install.sh.

## FTP Server

By default, the FTP username is 'ftp' and the password is 'ftp'.

## SSH Server
By default, the SSH username is 'root' and the password is 'root'.

## Plugins
You can pass a semi-colon seperated string for WordPress plugin slugs into the PLUGINS environmental and the image will install the plugins for you.


Follow me on twitter
@notmilobejda
