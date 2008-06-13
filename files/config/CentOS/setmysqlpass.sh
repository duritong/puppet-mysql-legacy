#!/bin/sh

test $# -gt 0 || exit 1

/sbin/service mysqld stop

/usr/libexec/mysqld --skip-grant-tables --user=root &
sleep 5
echo "USE mysql; UPDATE user SET Password=PASSWORD('$1') WHERE User='root' AND Host='localhost';" | mysql -u root
killall mysqld

/sbin/service mysqld start

