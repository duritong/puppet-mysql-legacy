class mysql::server::debian inherits mysql::server::clientpackage {
    File['mysql_data_dir'] {
        path => '/var/lib/mysql',
    }
    File['mysql_ibdata1'] {
        path => '/var/lib/mysql/ibdata1',
    }
}
