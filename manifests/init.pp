# mysql.pp
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# See LICENSE for the full license granted to you.

class mysql::server {

    $modulename = "mysql"
    $pkgname = "mysql"
    $gentoocat = "dev-db"
    $cnfname = "my.cnf"
    $cnfpath = "/etc/mysql"

    package { $pkgname:
        ensure => present,
        category => $operatingsystem ? {
            gentoo => $gentoocat,
            default => '',
        }
    }

    file{
        "${cnfpath}/${cnfname}":
            source => [
                "puppet://$server/dist/${modulename}/${fqdn}/${cnfname}",
                "puppet://$server/${modulename}/${fqdn}/${cnfname}",
                "puppet://$server/${modulename}/${cnfname}"
            ],
            ensure => file,
            owner => root,
            group => 0,
            mode => 0444,
            require => Package[$pkgname],
            notify => Service[$pkgname],
    }

	service { $pkgname:
		ensure => running,
		hasstatus => true,
		require => Package[$pkgname],
	}

	munin::plugin {
		[mysql_bytes, mysql_queries, mysql_slowqueries, mysql_threads]:
	}

	# Collect all databases and users
	Mysql_database<<||>>
	Mysql_user<<||>>
	Mysql_grant<<||>>

}
