class mysql::client::base {

  package { 'mysql':
    ensure => present,
    alias => 'mysql-client',
  }

}
