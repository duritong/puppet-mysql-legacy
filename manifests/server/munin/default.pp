# manage plugins
class mysql::server::munin::default {
  mysql_user{'munin@localhost':
    password_hash => mysql_password($mysql::server::munin_password),
    require       => Exec['mysql_set_rootpw'],
  }

  mysql_grant{'munin@localhost':
    privileges  => 'select_priv',
    require     => Mysql_user['munin@localhost'],
  }

  munin::plugin {
    [mysql_queries, mysql_slowqueries]:
      config  => "env.mysqlopts --user=munin --password='${mysql::server::munin_password}' -h localhost",
      require => Mysql_grant['munin@localhost'];
    [mysql_bytes, mysql_threads]:
      config  => "env.mysqlopts --user=munin --password=${mysql::server::munin_password} -h localhost",
      require => Mysql_grant['munin@localhost'];
  }

  Munin::Plugin::Deploy{
      config  => "env.mysqlopts --user=munin --password='${mysql::server::munin_password}' -h localhost",
      require => Mysql_grant['munin@localhost'],
  }
  munin::plugin::deploy{
    'mysql_connections':
      source => 'mysql/munin/mysql_connections';
    'mysql_qcache':
      source => 'mysql/munin/mysql_qcache';
    'mysql_qcache_mem':
      source => 'mysql/munin/mysql_qcache_mem';
    'mysql_size_all':
      source => 'mysql/munin/mysql_size_all';
  }
}
