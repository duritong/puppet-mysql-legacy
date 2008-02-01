err("Removing the user grant")

mysql_grant { "test_user@%": privileges => [] }


