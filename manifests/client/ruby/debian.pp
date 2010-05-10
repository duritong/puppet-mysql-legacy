class mysql::client::ruby::debian {

  package { 'libmysql-ruby':
    ensure => present,
  }

}
