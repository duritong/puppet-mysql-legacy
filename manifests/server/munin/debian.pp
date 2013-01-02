# debian way of calling plugins
class mysql::server::munin::debian inherits mysql::server::munin::default {
  Munin::Plugin['mysql_bytes']{
    config => "user root\nenv.mysqlopts --defaults-file=/etc/mysql/debian.cnf",
    require => Package['mysql'],
  }
  Munin::Plugin['mysql_queries']{
    config => "user root\nenv.mysqlopts --defaults-file=/etc/mysql/debian.cnf",
    require => Package['mysql'],
  }
  Munin::Plugin['mysql_slowqueries']{
    config => "user root\nenv.mysqlopts --defaults-file=/etc/mysql/debian.cnf",
    require => Package['mysql'],
  }
  Munin::Plugin['mysql_threads']{
    config => "user root\nenv.mysqlopts --defaults-file=/etc/mysql/debian.cnf",
    require => Package['mysql'],
  }
  Munin::Plugin::Deploy['mysql_connections']{
    config => "user root\nenv.mysqlopts --defaults-file=/etc/mysql/debian.cnf",
    require => Package['mysql'],
  }
  Munin::Plugin::Deploy['mysql_qcache']{
    config => "user root\nenv.mysqlopts --defaults-file=/etc/mysql/debian.cnf",
    require => Package['mysql'],
  }
  Munin::Plugin::Deploy['mysql_cache_mem']{
    config => "user root\nenv.mysqlopts --defaults-file=/etc/mysql/debian.cnf",
    require => Package['mysql'],
  }
  Munin::Plugin::Deploy['mysql_size_all']{
    config => "user root\nenv.mysqlopts --defaults-file=/etc/mysql/debian.cnf",
    require => Package['mysql'],
  }
}
