#!/usr/bin/env bash

username="nyrahul@gmail.com"
logf=/tmp/tmate.config$$
prereq()
{
	[[ "$username" == "" ]] && usage
	command -v tmate >/dev/null 2>&1 || { echo >&2 "tmate not found."; exit 1; }
	rm /tmp/tmate.config*
}

usage()
{
	echo "Usage: $0 <email-id>"
	echo "It is assumed that the setup is already done as part of tmate-setup.sh"
	exit 1
}

start_tmate()
{
	stdbuf -o0 tmate -F | tee $logf &
	while [ 1 ]; do
		grep "ssh session:" $logf >/dev/null
		[[ $? -eq 0 ]] && break
		sleep 1
	done
	echo "Sending mail to $username..."
	data=`cat $logf`
	printf "Subject: tmate details\n\n$data" | ssmtp $username
	wait
}

main()
{
	prereq
	start_tmate
}

main
