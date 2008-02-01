err("Grant DELETE to test_user@%")

mysql_grant {
	"test_user@%":
		privileges => [ "select_priv", 'insert_priv', 'delete_priv' ],
}


