#!/bin/sh

DB_PATH=/var/lib/spectrum
EXPIRE=100

for tr in $DB_PATH/*;
do
	DB=$tr/database.sqlite
	test -f $DB || continue

	was=`echo "SELECT COUNT(id) FROM users;"| sqlite3 $DB`
	old=`echo "SELECT COUNT(id) FROM users WHERE last_login<DATE('now','-$EXPIRE days');"| sqlite3 $DB`
	echo $tr: $was - $old
	echo "SELECT id FROM users WHERE last_login<DATE('now','-$EXPIRE days');"| sqlite3 $DB | \
		awk '{\
			printf "DELETE FROM buddies WHERE user_id=%s;\n",$1; \
			printf "DELETE FROM buddies_settings WHERE user_id=%s;\n", $1; \
			printf "DELETE FROM users WHERE id=%s;\n", $1; \
		}' | sqlite3 $DB

	all=`echo "SELECT COUNT(id) FROM users;"| sqlite3 $DB`
	
done
