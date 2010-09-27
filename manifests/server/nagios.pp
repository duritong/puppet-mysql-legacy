# manifests/server/nagios.pp

class mysql::server::nagios::base {
  
  case $nagios_mysql_password {
    '': { fail("please specify \$nagios_mysql_password to enable nagios mysql check")}
  }
  
  mysql_user{$nagios_mysql_user:
    password_hash => mysql_password("${nagios_mysql_password}"),
    require => Package['mysql'],
  }
  
  mysql_grant{$nagios_mysql_user:
    privileges => 'select_priv',
    require => [ Mysql_user[$nagios_mysql_user], Package['mysql'] ],
  }
}

class mysql::server::nagios inherits mysql::server::nagios::base {
      
    # Flip this variable if you need to check MySQL through check_ssh or check_nrpe,
    # in that case you will have to manually define nagios::service::mysql
    if ($nagios_mysql_notcp != true) {
        $nagios_mysql_user = 'nagios@%'
        nagios::service::mysql { 'mysql':
            check_hostname => $fqdn,
            check_username => 'nagios',
            check_password => $nagios_mysql_password,
            check_mode => 'tcp',
            require => Mysql_grant[$nagios_mysql_user],
        }
    }
    else {
        $nagios_mysql_user = 'nagios@localhost'
    }
}

class mysql::server::nagios::check_health inherits mysql::server::nagios::base {

  nagios::plugin{'check_mysql_health':
    source => 'mysql/nagios/check_mysql_health';
  }
  
  @@nagios_command{
    'check_mysql_health':
      command_line => '$USER1$/check_mysql_health --hostname $ARG1$ --port $ARG2$ --username $ARG3$ --password $ARG4$ --mode $ARG5$ --database $ARG6$',
      require => Nagios::Plugin['check_mysql_health'];
  }

  case $mysql_nagios_user {
    '': { $mysql_nagios_user = 'nagios' }
  }

  if ($nagios_mysql_notcp != true) {
    $nagios_mysql_user = 'nagios@%'
  }
  else {
    $nagios_mysql_user = 'nagios@localhost'
  }
}
