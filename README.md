# Bash scripts to interact with Portainer

# [Stack Update {stack-name} {composer-file.yml}](https://github.com/docker-how-to/portainer-bash-scripts/blob/master/stack-update.sh)
... will update a running stack with the name given as first parameter with the yml content from the file given as the second parameter

Requires:
* bash (or sh)
* jq
* curl

Usage:

* Set the following environmental variables or edit file and set the authentication details
```bash
P_USER="root"
P_PASS="password"
P_URL="http://example.com:9000"
P_PRUNE="false"
P_ENDPOINT="My Endpoint"
```

* run with
```bash
export P_USER="root"
export P_PASS="password"
export P_URL="http://example.com:9000"
export P_PRUNE="false"
./stack-update.sh mqtt mqtt/docker-compose.yml
```
