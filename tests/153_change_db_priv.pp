err("Change DELETE to UPDATE privilege for test_user@%test_db")

mysql_grant {
	"test_user@%test_db":
		privileges => [ "select_priv", 'insert_priv', 'update_priv'],
}


