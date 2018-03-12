# iocage-plugin-mineos
Artifact file(s) for MineOS iocage plugin

## To install this Plugin
Download the plugin manifest file to your local file system.
```
fetch https://raw.githubusercontent.com/jsegaert/iocage-my-plugins/master/mineos.json
```
Install the plugin.  Adjust host interface and IP address as needed.  
```
iocage fetch -P -n mineos.json ip4_addr="em0|192.168.0.100"
```
