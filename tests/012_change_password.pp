
err("Changing password for user 'test_user@%'")
mysql_user{ "test_user@%":
	password_hash => mysql_password("foo"),
	ensure => present
}
