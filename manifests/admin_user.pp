# add an admin user that has
# access to all databases
define mysql::admin_user(
  $password,
  $ensure = present,
  $host = '127.0.0.1'
){
  $password_hash = $password ? {
    'trocla' => trocla("mysql_admin-user_${name}",'mysql'),
    default => $password,
  }
  mysql_user{"${name}@${host}":
    ensure        => $ensure,
    password_hash => $password_hash,
    require       => Exec['mysql_set_rootpw'],
  }
  mysql_grant{"${name}@${host}":
    privileges  => 'all',
    require     => Mysql_user["${name}@${host}"],
  }
}
