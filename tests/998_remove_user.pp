
err("Removing user 'test_user@%'")
mysql_user{ "test_user@%": ensure => absent }
