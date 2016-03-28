# basic mysql client stuff
class mysql::client::base {
  package { 'mysql':
    ensure => present,
    alias  => 'mysql-client',
  }
  if $::operatingsystem in ['RedHat', 'CentOS'] and
    versioncmp($::operatingsystemmajrelease,'6') > 0 {
      Package['mysql']{
        name => 'mariadb'
      }
  }
}
