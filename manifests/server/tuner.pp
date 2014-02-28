# install mysqltuner package
class mysql::server::tuner {
  package{'mysqltuner':
    ensure => present,
  }
}
