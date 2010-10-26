# manifests/server/munin/default.pp

class mysql::server::munin::default inherits mysql::server::munin::base {
    case $munin_mysql_password {
        '': { fail("please specify \$munin_mysql_password to enable mysql munin plugin")}
    }

    mysql_user{'munin@localhost':
        password_hash => mysql_password("$munin_mysql_password"),
        require => Package['mysql'],
    }

    mysql_grant{'munin@localhost':
        privileges => 'select_priv',
        require => [ Mysql_user['munin@localhost'], Package['mysql'] ],
    }

    munin::plugin {
        [mysql_bytes, mysql_queries, mysql_slowqueries, mysql_threads, mysql_connections, mysql_qcache, mysql_cache_mem, mysql_size_all]:
            config => "env.mysqlopts --user=munin --password=${munin_mysql_password} -h localhost",
            require => [ Mysql_grant['munin@localhost'], Mysql_user['munin@localhost'], Package['mysql'] ]
    }
}
