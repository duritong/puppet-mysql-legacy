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
      [ mysql_bytes, mysql_queries, mysql_slowqueries, mysql_threads ]:
        config => "env.mysqlopts --user=munin --password=${munin_mysql_password} -h localhost",
        require => [ Mysql_grant['munin@localhost'], Mysql_user['munin@localhost'], Package['mysql'] ];

      [ mysql_connections, mysql_qcache, mysql_cache_mem, mysql_size_all ]:
        script_path_in => "/usr/local/share/munin-plugins",
        config => "env.mysqlopts --user=munin --password=${munin_mysql_password} -h localhost",
        require => [ Mysql_grant['munin@localhost'], Mysql_user['munin@localhost'], Package['mysql'] ];
    }

    Munin::Plugin::Deploy {
      config => "env.mysqlopts --user=munin --password=$munin_mysql_password -h localhost",
      require =>
      [ Mysql_grant['munin@localhost'],
        Mysql_user['munin@localhost'],
        Package['mysql'] ]
    }
    munin::plugin::deploy{
      'mysql_connections':
        source => 'mysql/munin/mysql_connections';
      'mysql_qcache':
        source => 'mysql/munin/mysql_qcache';
      'mysql_qcache_mem':
        source => 'mysql/munin/mysql_qcache_mem';
    }
}
