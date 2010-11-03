class mysql::client::perl::debian {

  package { 'libdbd-mysql-perl':
    ensure => present,
  }
}
