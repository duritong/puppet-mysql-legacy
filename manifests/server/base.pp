# manage the common things of
# a mysql server
class mysql::server::base {
  package {'mysql-server':
    ensure => present,
  }
  file { 'mysql_main_cnf':
    path    => '/etc/mysql/my.cnf',
    source  => [
      "puppet:///modules/site_mysql/${::fqdn}/my.cnf",
      "puppet:///modules/site_mysql/my.cnf.${::operatingsystem}.{lsbdistcodename}",
      "puppet:///modules/site_mysql/my.cnf.${::operatingsystem}",
      'puppet:///modules/site_mysql/my.cnf',
      "puppet:///modules/mysql/config/my.cnf.${::operatingsystem}.{lsbdistcodename}",
      "puppet:///modules/mysql/config/my.cnf.${::operatingsystem}",
      'puppet:///modules/mysql/config/my.cnf'
    ],
    require => Package['mysql-server'],
    notify  => Service['mysql'],
    owner   => root,
    group   => 0,
    mode    => '0644';
  }

  file {
    'mysql_data_dir':
      ensure  => directory,
      path    => '/var/lib/mysql/data',
      require => Package['mysql-server'],
      before  => File['mysql_main_cnf'],
      owner   => mysql,
      group   => mysql,
      mode    => '0755';
    'mysql_ibdata1':
      path    => '/var/lib/mysql/data/ibdata1',
      require => Package['mysql-server'],
      before  => File['mysql_setmysqlpass.sh'],
      owner   => mysql,
      group   => mysql,
      mode    => '0660';
    'mysql_setmysqlpass.sh':
      path    => '/usr/local/sbin/setmysqlpass.sh',
      source  => "puppet:///modules/mysql/scripts/${::operatingsystem}/setmysqlpass.sh",
      require => Package['mysql-server'],
      owner   => root,
      group   => 0,
      mode    => '0500';
    'mysql_root_cnf':
      path    => '/root/.my.cnf',
      content => template('mysql/root/my.cnf.erb'),
      require => [ Package['mysql-server'] ],
      notify  => Exec['mysql_set_rootpw'],
      owner   => root,
      group   => 0,
      mode    => '0400';
  }

  exec { 'mysql_set_rootpw':
    command     => '/usr/local/sbin/setmysqlpass.sh',
    unless      => 'mysqladmin -uroot status > /dev/null',
    require     => [ File['mysql_setmysqlpass.sh'], Service['mysql'] ],
    # this is for security so that we only change the password
    # if the password file itself has changed
    refreshonly => true,
  }

  if $mysql::server::backup_cron {
    include mysql::server::cron::backup
  }

  if $mysql::server::optimize_cron {
    include mysql::server::cron::optimize
  }

  service { 'mysql':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => Package['mysql-server'],
  }

  if $::mysql_exists == 'true' {
    include mysql::server::account_security

    # Collect all databases and users
    Mysql_database<<| tag == "mysql_${::fqdn}" |>>
    Mysql_user<<| tag == "mysql_${::fqdn}"  |>>
    Mysql_grant<<| tag == "mysql_${::fqdn}" |>>
  }
}
