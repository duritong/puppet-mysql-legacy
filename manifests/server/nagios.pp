# manifests/server/nagios.pp

class mysql::server::nagios {
  case $nagios_mysql_password {
    '': { fail("please specify \$nagios_mysql_password to enable nagios mysql check")}
  }
  
  # Flip this variable if you need to check MySQL through check_ssh or check_nrpe,
  # in that case you will have to manually define nagios::service::mysql
  if ($nagios_mysql_notcp != true) {
    $nagios_mysql_user = 'nagios@%'
    nagios::service::mysql { 'connection-time':
      check_hostname => $fqdn,
      require => Mysql_grant[$nagios_mysql_user],
    }
  }
  else {
    $nagios_mysql_user = 'nagios@localhost'
  }
  
  mysql_user{$nagios_mysql_user:
    password_hash => mysql_password("${nagios_mysql_password}"),
    require => Package['mysql'],
  }
  
  # repl_client_priv is needed to check the replication slave status
  # modes: slave-lag, slave-io-running and slave-sql-running
  mysql_grant{$nagios_mysql_user:
    privileges => [ 'select_priv', 'repl_client_priv' ],
    require => [ Mysql_user[$nagios_mysql_user], Package['mysql'] ],
  }
}
