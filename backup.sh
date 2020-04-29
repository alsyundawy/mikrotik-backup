#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${DIR}/mikrotik_backup.settings

for r in ${routers[@]}; do
    cmd_backup="/system backup save name=${r}.backup"
    ssh ${login}@$r -i $privatekey "${cmd_backup}" > /dev/null
    cmd_backup="/export file=${r}"
    ssh ${login}@$r -i $privatekey "${cmd_backup}" > /dev/null
    sleep 5
    mkdir -p $fulldir
    wget -qP $fulldir ftp://${login}:${passwd}@${r}/${r}.backup
    wget -qP $fulldir ftp://${login}:${passwd}@${r}/${r}.rsc
    ssh ${login}@$r -i $privatekey "/file remove \"${r}.backup\""
    ssh ${login}@$r -i $privatekey "/file remove \"${r}.rsc\""
done
