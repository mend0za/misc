#!/bin/bash

set -e

PIXMAP=/status-icons

SERVER_STATUS="stopped"
ONLINE=$PIXMAP/available.png
OFFLINE=$PIXMAP/offline.png
STATFILE=/var/www/jabber.org.by/stats.new
STATFILE_DEST=/var/www/jabber.org.by/stats


JID="support@jabber.org.by"
JID_PASSWORD="some password, of course"
STATUS_UTIL="/usr/local/sbin/stats.py"


SPECTRUMCTL=/usr/bin/spectrumctl
SPECTRUMCONF=/etc/spectrum/
SERVER=jabber.org.by

$STATUS_UTIL $JID $JID_PASSWORD $SERVER | grep -q "users_all_hosts_online" && SERVER_STATUS="running"
#c=`ps ax|grep beam.smp|wc -l`
#[ $c -eq 2 ] && SERVER_STATUS="running"
ejabberdctl status 2>&1 |grep -q "The node ejabberd@localhost is started with status: started" && SERVER_STATUS='running'


function spectrum_stats()
{
	local service
	local stats
	local status

	service=$1
	stats=`$STATUS_UTIL $JID $JID_PASSWORD $service.$SERVER`

	export online=`echo $stats|awk '/users_online/ {print $5}'`
	#export registered="N/A"
	export registered=`echo "SELECT COUNT(id) FROM users;"|sqlite3 /var/lib/spectrum/$service.$SERVER/database.sqlite`

	status=`echo -n $stats|wc -c`
	if [ "x$status" = "x0" ]
	then
		export status_line="<img src='$OFFLINE' alt='OFF'>"
	else
		export status_line="<img src='$ONLINE' alt='ON'>"
	fi

	#echo $service $online $registered $status_line
}


function server_status()
{

	if [ "x$SERVER_STATUS" = "xstopped" ]
	then
		#/etc/init.d/ejabberd stop 1>/dev/null 2>/dev/null
		#killall beam.smp 1>/dev/null 2>/dev/null
		#/etc/init.d/ejabberd start 1>/dev/null 2>/dev/null
		#sleep 5
		echo   "<img src='$OFFLINE' alt='OFF'>"
	else
		echo   "<img src='$ONLINE' alt='ON'>" 
	fi


}

if [ $SERVER_STATUS = "running" ]
then
	CONNECTED_USERS=`$STATUS_UTIL $JID $JID_PASSWORD jabber.org.by|awk '/users_all_hosts_online/ {print $2}'`
	JOB_USERS=`$STATUS_UTIL $JID $JID_PASSWORD jabber.org.by|awk '/users_total/ {print $2}'`
	JLB_USERS=`$STATUS_UTIL $JID $JID_PASSWORD jabber.linux.by|awk '/users_total/ {print $2}'`

fi

cat >$STATFILE <<EOF
<center>`LANG=C date`</center>
<hr>
<table class="status" >
<tr>
   <th class="name">service
   <th>state
   <th>online
   <th>total
</tr>

<tr class="server"> 
  <td class="name"> <b>server</b>
  <td> `server_status jabber.org.by`
  <td> $CONNECTED_USERS
  <td> $JOB_USERS+$JLB_USERS
</tr>
EOF

for service in icq facebook yahoo twitter msn aim xmpp j2j sipe vkontakte mrim
do 
	spectrum_stats $service

	cat >>$STATFILE <<EOF2
	<tr class="service">
  		<td class="name"> $service
  		<td> $status_line
  		<td> $online
  		<td> $registered
	</tr>
EOF2

done

echo "</table>" >>$STATFILE

mv $STATFILE $STATFILE_DEST
