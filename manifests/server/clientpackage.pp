class mysql::server::clientpackage inherits mysql::server::base {
    include mysql::client
    File['/opt/bin/setmysqlpass.sh']{
        require +> Package[mysql],
    }
    File['/root/.my.cnf']{
        require +> Package[mysql],
    }
    Exec['set_mysql_rootpw']{
        require +> Package[mysql],
    }
    File['/etc/cron.d/mysql_backup.cron']{
        require +> Package[mysql],
    }
}
