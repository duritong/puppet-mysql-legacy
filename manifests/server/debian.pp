class mysql::server::debian inherits mysql::server::clientpackage {
    File['mysql_data_dir'] {
        path => '/var/lib/mysql',
    }
    File['mysql_ibdata1'] {
        path => '/var/lib/mysql/ibdata1',
    }
    file { 'mysql_debian_cnf':
            path => '/etc/mysql/debian.cnf',
            ensure => file,
            notify => Service['mysql'],
            owner => root, group => 0, mode => 0600;
    }
}
