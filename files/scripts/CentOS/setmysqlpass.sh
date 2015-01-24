#!/bin/sh

test -f /root/.my.cnf || exit 1

rootpw=$(grep password /root/.my.cnf | sed -e 's/^[^=]*= *\(.*\) */\1/')

/usr/bin/mysqladmin -uroot --password="${rootpw}" status > /dev/null && echo "Nothing to do as the password already works" && exit 0

/usr/bin/systemctl stop mariadb

/usr/libexec/mysqld --skip-grant-tables --user=root --datadir=/var/lib/mysql/data --log-bin=/var/lib/mysql/mysql-bin --pid-file=/var/run/mariadb/mariadb.pid &
sleep 5
mysql -u root mysql <<EOF
UPDATE mysql.user SET Password=PASSWORD('$rootpw') WHERE User='root' AND Host='localhost';
DELETE FROM mysql.user WHERE (User='root' AND Host!='localhost') OR USER='';
FLUSH PRIVILEGES;
EOF
kill `cat /var/run/mariadb/mariadb.pid`
sleep 15
# chown to be on the safe side
ls -al /var/lib/mysql/mysql-bin.* &> /dev/null
[ $? == 0 ] && chown mysql.mysql /var/lib/mysql/mysql-bin.*
chown -R mysql.mysql /var/lib/mysql/data/

/usr/bin/systemctl start mariadb
