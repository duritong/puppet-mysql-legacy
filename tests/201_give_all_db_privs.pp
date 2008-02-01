err("Grant ALL to test_user@%/test_db")

mysql_grant {
	"test_user@%/test_db":
		privileges => all
}


