# basic mysql client stuff
class mysql::client::base {
  package { 'mysql':
    ensure => present,
    alias  => 'mysql-client',
  }
  if $::operatingsystem in ['RedHat', 'CentOS'] and
    $::operatingsystemmajrelease > 6 {
      Package[mysql]{
        name => 'mariadb'
      }
  }
}
