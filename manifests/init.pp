# mysql.pp
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# See LICENSE for the full license granted to you.

class mysql::server {

	package { "mysql":
        ensure => present,
        category => $operatingsystem ? {
            gentoo => 'dev-db',
            default => '',
        }
	}

	munin::plugin {
		[mysql_bytes, mysql_queries, mysql_slowqueries, mysql_threads]:
	}

	service { mysql:
		ensure => running,
		hasstatus => true,
		require => Package["mysql"],
	}

	# Collect all databases and users
	Mysql_database<<||>>
	Mysql_user<<||>>
	Mysql_grant<<||>>

}
