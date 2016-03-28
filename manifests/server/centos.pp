# centos specific things
class mysql::server::centos inherits mysql::server::clientpackage {
  if versioncmp($::operatingsystemmajrelease,'6') > 0 {
    Package['mysql-server']{
      name  => 'mariadb-server',
    }
    Service['mysql']{
      name  => 'mariadb',
    }
  } else {
    Service['mysql']{
      name  => 'mysqld',
    }
  }
  File['mysql_main_cnf']{
    path => '/etc/my.cnf',
  }

  file{
    '/etc/mysql':
      ensure  => directory,
      owner   => root,
      group   => 0,
      mode    => '0644';
    '/etc/mysql/conf.d':
      ensure  => directory,
      recurse => true,
      purge   => true,
      force   => true,
      owner   => root,
      group   => 0,
      mode    => '0644',
      notify  => Service['mysql'];
  }
}
