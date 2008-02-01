err("Create a db grant")

mysql_grant {
	"test_user@%test_db":
		privileges => [ "select_priv", 'insert_priv', 'update_priv' ],
		tag => test;
}


