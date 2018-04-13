# Bash scripts to interact with Portainer

# [Stack Update {stack-name} {composer-file.yml}](https://github.com/docker-how-to/portainer-bash-scripts/blob/master/stack-update.sh)
... will update a running stack with the name given as first parameter with the yml content from the file given as the second parameter

Requires:
* bash (or sh)
* jq
* curl

Usage:

* edit file and set the authentication details
```variables
P_USER="root" 
P_PASS="rootroot" 
P_URL="http://10.11.9.200:9000" 
P_PRUNE="false"
```

* run with
```console
./stack-update.sh mqtt mqtt/docker-compose.yml
```
