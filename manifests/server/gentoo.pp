class mysql::server::gentoo inherits mysql::server::base {
    Package['mysql-server'] {
        alias => 'mysql',
        category => 'dev-db',
    }
}
