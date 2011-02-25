class mysql::server::account_security {
   # some installations have some default users which are not required.
   # We remove them here. You can subclass this class to overwrite this behavior.
   mysql_user{ [ "root@${fqdn}", "root@127.0.0.1", "@${fqdn}", "@localhost", "@%" ]:
     ensure => 'absent',
     require => Service['mysql'],
   }
}
