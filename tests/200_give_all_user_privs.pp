err("Grant ALL to test_user@%")

mysql_grant {
	"test_user@%":
		privileges => all
}


