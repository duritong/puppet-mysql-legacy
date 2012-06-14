class mysql::server::nagios {
  # Flip this variable if you need to check MySQL through check_ssh or check_nrpe,
  # in that case you will have to manually define nagios::service::mysql
  if $mysql::server::nagios_notcp {
    $nagios_mysql_user = 'nagios@localhost'
  } else {
    $nagios_mysql_user = 'nagios@%'
    nagios::service::mysql { 'connection-time':
      check_hostname => $::fqdn,
      require => Mysql_grant[$nagios_mysql_user],
    }
  }

  mysql_user{$nagios_mysql_user:
    password_hash => trocla("mysql_nagios_${::fqdn}",'mysql','length: 32'),
    require => Package['mysql'],
  }

  # repl_client_priv is needed to check the replication slave status
  # modes: slave-lag, slave-io-running and slave-sql-running
  mysql_grant{$nagios_mysql_user:
    privileges => [ 'select_priv', 'repl_client_priv' ],
    require => [ Mysql_user[$nagios_mysql_user], Package['mysql'] ],
  }
}
