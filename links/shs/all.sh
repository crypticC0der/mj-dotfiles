#!/bin/bash
sh -c "~/shs/ebackup.sh &"
sh -c "~/shs/backup.sh &"
sh -c "~/shs/backchang.sh &"
sh -c "~/shs/refreshplaylist.sh &"
sh -c "~/shs/dropcache.sh &"
~/shs/shrekbot.sh &
