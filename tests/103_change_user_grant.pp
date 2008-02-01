err("Replace DELETE with UPDATE grant for test_user@%")

mysql_grant {
	"test_user@%":
		privileges => [ "select_priv", 'insert_priv', 'update_priv' ],
}


