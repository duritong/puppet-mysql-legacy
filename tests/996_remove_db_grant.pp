err("Remove the db grant")

mysql_grant { "test_user@%test_db": privileges => [ ] }


