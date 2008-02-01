
err("Will create user 'test_user@%' with password 'blah'")

mysql_user{ "test_user@%":
	password_hash => mysql_password("blah"),
	ensure => present
}
