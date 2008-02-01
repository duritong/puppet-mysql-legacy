err("Grant SELECT, INSERT and UPDATE to test_user@%")

mysql_grant {
	"test_user@%":
		privileges => [ "select_priv", 'insert_priv', 'update_priv' ],
		tag => test;
}


