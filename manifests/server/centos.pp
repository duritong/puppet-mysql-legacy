class mysql::server::centos inherits mysql::server::clientpackage {
    Service['mysql']{
        name  => 'mysqld',
    }
    File['mysql_main_cnf']{
        path => '/etc/my.cnf',
    }

}
