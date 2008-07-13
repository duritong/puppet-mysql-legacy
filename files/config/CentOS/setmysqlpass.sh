#!/bin/sh

test $# -gt 0 || exit 1

/sbin/service mysqld stop

/usr/libexec/mysqld --skip-grant-tables --user=root --datadir=/var/lib/mysql --log-bin=/var/lib/mysql/mysql-bin &
sleep 5
echo "USE mysql; UPDATE user SET Password=PASSWORD('$1') WHERE User='root' AND Host='localhost';" | mysql -u root
killall mysqld
# chown to be on the safe side
chown mysql.mysql /var/lib/mysql/mysql-bin.*

/sbin/service mysqld start

