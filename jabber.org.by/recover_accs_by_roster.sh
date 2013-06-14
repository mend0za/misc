#!/bin/bash

MY_HOSTS="jabber.org.by jabber.linux.by"
JOB_USERS=`ejabberdctl registered_users jabber.org.by`
JLB_USERS=`ejabberdctl registered_users jabber.linux.by`


revert_back()
{
	local login=$1
	local host=$2

	echo "$login@$host"
}

check_existance() 
{
	local acc
	while read acc
	do
		local host=`echo "$acc"|sed 's/.*@//g'`
		local login=`echo "$acc"|sed 's/@.*//g'`

		#echo "$acc"

		case "$host" in
			jabber.org.by)
				echo $JOB_USERS|egrep -q "${login}"  || \
					( echo "$acc"; ejabberdctl change_password "$login" "$host" "recover_$login-$RANDOM" )

				;;
			jabber.linux.by)
				echo $JLB_USERS|egrep -q "${login}"  || \
					( echo "$acc"; ejabberdctl change_password "$login" "$host" "recover_$login-$RANDOM" )
				;;
		esac


	done 
	#echo $JOB_USERS $JOL_USERS| grep -q "$1" || echo "$1" 
}


for host in $MY_HOSTS
do
	for user in `ejabberdctl registered_users $host`
	do
		ejabberdctl get_roster $user $host
	done
done |awk '$1 ~ /@jabber\.(org|linux)\.by/ {print $1}'| sort | uniq | check_existance


