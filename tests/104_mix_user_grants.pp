err("Change the order of the defined privileges")

mysql_grant {
	"test_user@%":
		privileges => [ "update_priv", 'insert_priv', 'select_priv' ],
}


