# manifests/server/nagios.pp

class mysql::server::nagios {  
  case $nagios_mysql_password {
    '': { fail("please specify \$nagios_mysql_password to enable nagios mysql check")}
  }

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

  nagios::plugin::deploy{'check_mysql_health':
    source => 'mysql/nagios/check_mysql_health',
    require_package => 'libdbd-mysql-perl';
  }
  
  @@nagios_command{
    'check_mysql_health':
      command_line => '$USER1$/check_mysql_health --hostname $ARG1$ --port $ARG2$ --username $ARG3$ --password $ARG4$ --mode $ARG5$ --database $ARG6$';
  }

  define check_health (
    $ensure = present,
    $check_hostname = $fqdn,
    $check_port = '3306',
    $check_username = 'nagios',
    $check_password = $nagios_mysql_password,
    $check_database = 'information_schema',
    $check_warning = undef,
    $check_critical = undef,
    $check_health_mode = $name,
    $check_name = undef,
    $check_name2 = undef,
    $check_regexp = undef,
    $check_units = undef,
    $check_mode = 'tcp' )
  {    
    case $check_mode {
      'tcp': {
        if ($check_hostname == 'localhost') {
          $real_check_hostname = '127.0.0.1'
        }
        else {
          $real_check_hostname = $check_hostname
        }
      }
      default: {
        if ($check_hostname == '127.0.0.1') {
          $real_check_hostname = 'localhost'
        }
        else {
          $real_check_hostname = $check_hostname
        }
      }
    }
    nagios::service { "mysql_health_${name}":
      ensure        => $ensure,
      check_command => "check_mysql_health!${check_hostname}!${check_port}!${check_username}!${check_password}!${name}!${check_database}",
    }
  }
}
