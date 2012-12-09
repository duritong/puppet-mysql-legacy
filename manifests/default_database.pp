# create default database
define mysql::default_database(
  $username = 'absent',
  $password = 'absent',
  $password_is_encrypted = true,
  $privileges = 'all',
  $host = '127.0.0.1',
  $ensure = 'present'
) {
  $real_username = $username ? {
    'absent' => $name,
    default => $username
  }
  mysql_database{$name:
    ensure  => $ensure,
    require => Exec['mysql_set_rootpw'],
  }
  if $password == 'absent' and $ensure != 'absent' {
      info("we don't create the user for database: ${name}")
      $grant_require = Mysql_database[$name]
  } else {
    mysql_user{"${real_username}@${host}":
      ensure  => $ensure,
      require => Mysql_database[$name],
    }
    $grant_require = Mysql_user["${real_username}@${host}"]
    if $ensure == 'present' {
        $password_hash = $password ? {
          'trocla'  => trocla("mysql_${real_username}",'mysql'),
          default   => $password_is_encrypted ? {
            true    => $password,
            default => mysql_password($password)
          },
        }
      Mysql_user["${real_username}@${host}"]{
        password_hash => $password_hash
      }
    }
  }
  if $ensure == 'present' {
    mysql_grant{"${real_username}@${host}/${name}":
      privileges  => $privileges,
      require     => $grant_require,
    }
  }
}
