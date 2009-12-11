# manifests/server/nagios.pp

class mysql::server::nagios {
    case $nagios_mysql_password {
        '': { fail("please specify \$nagios_mysql_password to enable nagios mysql check")}
    }

    mysql_user{'nagios@localhost':
        password_hash => mysql_password("${nagios_mysql_password}"),
        require => Package['mysql'],
    }

    mysql_grant{'nagios@localhost':
        privileges => 'select_priv',
        require => [ Mysql_user['nagios@localhost'], Package['mysql'] ],
    }
    
    # Flip this variable if you need to check MySQL through check_ssh or check_nrpe,
    # in that case you will have to manually define nagios::service::mysql
    if ($nagios_mysql_notcp != true) {
        nagios::service::mysql { 'mysql':
            check_hostname => $fqdn,
            check_username => 'nagios',
            check_password => $nagios_mysql_password,
            check_mode => 'tcp',
        }
    }
}
