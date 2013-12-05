# centos specific things
class mysql::server::centos inherits mysql::server::clientpackage {
  Service['mysql']{
    name  => 'mysqld',
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
