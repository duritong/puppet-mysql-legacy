class mysql::devel{
  package{"mysql-devel.${::architecture}":
    ensure => present,
  }
}
