#!/bin/sh

test -f /root/.my.cnf || exit 1

rootpw=$(grep password /root/.my.cnf | sed -e 's/^[^=]*= *\(.*\) */\1/')

/sbin/service mysqld stop

/usr/libexec/mysqld --skip-grant-tables --user=root --datadir=/var/lib/mysql/data --log-bin=/var/lib/mysql/mysql-bin &
sleep 5
mysql -u root mysql <<EOF
UPDATE mysql.user SET Password=PASSWORD('$rootpw') WHERE User='root' AND Host='localhost';
FLUSH PRIVILEGES;
EOF
killall mysqld
# chown to be on the safe side
chown mysql.mysql /var/lib/mysql/mysql-bin.*

/sbin/service mysqld start

