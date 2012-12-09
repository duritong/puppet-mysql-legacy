# manage plugins
class mysql::server::munin::default {
  mysql_user{'munin@localhost':
    password_hash => trocla("mysql_munin_${::fqdn}",'mysql','length: 32'),
    require       => Exec['mysql_set_rootpw'],
  }

  mysql_grant{'munin@localhost':
    privileges  => 'select_priv',
    require     => Mysql_user['munin@localhost'],
  }

  $munin_mysql_password = trocla("mysql_munin_${::fqdn}",'plain', 'length: 32')
  munin::plugin {
    [mysql_bytes, mysql_queries, mysql_slowqueries, mysql_threads]:
      config  => "env.mysqlopts --user=munin --password='${munin_mysql_password}' -h localhost",
      require => Mysql_grant['munin@localhost'],
  }

  Munin::Plugin::Deploy{
      config  => "env.mysqlopts --user=munin --password='${munin_mysql_password}' -h localhost",
      require => Mysql_grant['munin@localhost'],
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
