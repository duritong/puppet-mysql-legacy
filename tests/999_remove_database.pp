err("Will remove 'test_db'")
mysql_database { "test_db": ensure => absent }

