define mysql::admin_user(
  $ensure = present,
  $host = '127.0.0.1',
  $password
){
  mysql_user{"${name}@${host}":
    ensure => $ensure,
    password_hash => $password ? {
      'trocla' => trocla("mysql_admin-user_${name}",'mysql'),
      default => $password,
    },
  }
  mysql_grant{"${name}@${host}":
    privileges => 'all',
    require => Mysql_user["${name}@${host}"],
  }
}
