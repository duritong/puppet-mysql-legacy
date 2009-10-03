class mysql::server::centos inherits mysql::server::clientpackage {
    Service[mysql]{
        name  => 'mysqld',
    }
    File['/etc/mysql/my.cnf']{
        path => '/etc/my.cnf',
    }

}
