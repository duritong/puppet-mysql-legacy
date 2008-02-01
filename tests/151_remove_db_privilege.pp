err("Revoke UPDATE from test_user@%test_db")

mysql_grant {
	"test_user@%test_db":
		privileges => [ "select_priv", 'insert_priv'],
}


