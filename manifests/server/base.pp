class mysql::server::base {
    package { mysql-server:
        ensure => present,
    }
    file { 'mysql_main_cnf':
            path => '/etc/mysql/my.cnf',
            source => [
                "puppet://modules/site-mysql/${fqdn}/my.cnf",
                "puppet://modules/site-mysql/my.cnf.${operatingsystem}.{lsbdistcodename}",
                "puppet://modules/site-mysql/my.cnf.${operatingsystem}",
                "puppet://modules/site-mysql/my.cnf",
                "puppet://modules/mysql/config/my.cnf.${operatingsystem}.{lsbdistcodename}",
                "puppet://modules/mysql/config/my.cnf.${operatingsystem}",
                "puppet://modules/mysql/config/my.cnf"
            ],
            ensure => file,
            require => Package['mysql-server'],
            notify => Service['mysql'],
            owner => root, group => 0, mode => 0644;
    }
    
    file { 'mysql_data_dir':
        path => '/var/lib/mysql/data',
        ensure => directory,
        require => Package['mysql-server'],
        before => File['mysql_main_cnf'],
        owner => mysql, group => mysql, mode => 0755;
    }

    file { 'mysql_ibdata1':
        path => '/var/lib/mysql/data/ibdata1',
        ensure => file,
        require => Package['mysql-server'],
        before => File['mysql_setmysqlpass.sh'],
        owner => mysql, group => mysql, mode => 0660;
    }

    case $mysql_rootpw {
        '': { fail("You need to define a mysql root password! Please set \$mysql_rootpw in your site.pp or host config") }
    }
    
    file { 'mysql_setmysqlpass.sh':
        path => '/usr/local/sbin/setmysqlpass.sh',
        source => "puppet:///modules/mysql/scripts/${operatingsystem}/setmysqlpass.sh",
        require => Package['mysql-server'],
        owner => root, group => 0, mode => 0500;
    }    
        
    file { 'mysql_root_cnf':
        path => '/root/.my.cnf',
        content => template('mysql/root/my.cnf.erb'),
        require => [ Package['mysql-server'] ],
        owner => root, group => 0, mode => 0400,
        notify => Exec['mysql_set_rootpw'],
    }
    
    exec { 'mysql_set_rootpw':
        command => "/usr/local/sbin/setmysqlpass.sh ${mysql_rootpw}",
        unless => "mysqladmin -uroot status > /dev/null",
        require => [ File['mysql_setmysqlpass.sh'], Package['mysql-server'] ],
        refreshonly => true,
    }
    
    if ($mysql_backup_cron) {
        include mysql::server::cron::backup
    }
    
    if ($mysql_optimize_cron) {
        include mysql::server::cron::optimize
    }
   
    service { 'mysql':
        ensure => running,
        enable => true,
        hasstatus => true,
        require => Package['mysql-server'],
   }

    # Collect all databases and users
    Mysql_database<<| tag == "mysql_${fqdn}" |>>
    Mysql_user<<| tag == "mysql_${fqdn}"  |>>
    Mysql_grant<<| tag == "mysql_${fqdn}" |>>
}
