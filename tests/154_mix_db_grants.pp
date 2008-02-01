err("Change privilege order")

mysql_grant {
	"test_user@%test_db":
		privileges => [ "update_priv", 'insert_priv', 'select_priv'],
}


