#!/bin/bash

function usage()
{
    cat <<EOH
    Usage: $0 <filename>
    If the file is already present then check if there is a header already. If not, add it.
    If the file is not present add a header to the file.
EOH
    exit 1
}

function handle()
{
    [[ -f "$1" ]] && echo "$1 file already present" && return
    cat $hdrFile >> $1
}

[[ "$1" == "" ]] && usage

type=${1/*./}
HDR_FILE=".header.$type"

curDir=`realpath "$1"`
curDir=`dirname "$curDir"`
while [ "$curDir" != "/" ]; do
    hdrFile="$curDir/$HDR_FILE"
    echo "chking $hdrFile ..."
    if [ -f "$hdrFile" ]; then
        echo "Found $hdrFile ..."
        handle "$1" "$hdrFile"
        exit
    fi
    curDir=`dirname "$curDir"`
done
echo "Could not find [$HDR_FILE] anywhere on the path"
