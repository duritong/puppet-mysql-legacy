#!/bin/sh

test $# -gt 0 || exit 1

/etc/init.d/mysql stop

/usr/sbin/mysqld --skip-grant-tables --user=root --datadir=/var/lib/mysql --log-bin=/var/lib/mysql/mysql-bin &
sleep 5
echo "USE mysql; UPDATE user SET Password=PASSWORD('$1') WHERE User='root' AND Host='localhost';" | mysql -u root
killall mysqld
sleep 5
# chown to be on the safe side
ls -al /var/lib/mysql/mysql-bin.* &> /dev/null
[ $? == 0 ] && chown mysql.mysql /var/lib/mysql/mysql-bin.*

/etc/init.d/mysql start

