# MineOS - Minecraft server management
This plugin provides a convenient way to install the node.js implementation of MineOS in a FreeBSD jail using the [iocage](https://github.com/iocage/iocage) jail manager.

MineOS is a web front-end to set up and manage Minecraft servers with a few mouse clicks.
For more info on the project, see [https://github.com/hexparrot/mineos-node](https://github.com/hexparrot/mineos-node)

## To install this Plugin
Download the plugin manifest file to your local file system.
```
fetch https://raw.githubusercontent.com/jsegaert/iocage-my-plugins/master/mineos.json
```
Install the plugin.  Adjust the network settings as needed.
```
iocage fetch -P mineos.json -n mineos
```

## Default settings
* The web admin page is accesible at http://xxx.yyy.zzz.aaa:8443/
* The default user is "mcserver" with password "mcserver"
* The data directory is /var/games/minecraft

## Customization

To change the default settings, edit the configuration file `/etc/mineos.conf` and restart the mineos service

User management is done via FreeBSD's standard tools, e.g.

* `passwd mcserver` to change the default password for user mcserver
* `adduser` to create additional users

