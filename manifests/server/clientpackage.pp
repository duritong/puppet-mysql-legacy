# include client package
class mysql::server::clientpackage inherits mysql::server::base {
  class { 'mysql::client':
    manage_shorewall => $mysql::server::manage_shorewall,
  }
  File['mysql_setmysqlpass.sh']{
    require +> Package['mysql'],
  }
  File['mysql_root_cnf']{
    require +> Package['mysql'],
  }
  Exec['mysql_set_rootpw']{
    require +> Package['mysql'],
  }
}
