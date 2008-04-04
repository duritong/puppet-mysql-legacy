# mysql.pp
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# See LICENSE for the full license granted to you.
# changed by immerda project group (admin(at)immerda.ch)

class mysql::server {
    case $operatingsystem {
        gentoo: { include mysql::server::gentoo }
        default: { include mysql::server::base }
    }
}

class mysql::server::base {
    package { mysql:
        ensure => present,
    }

    file{
        "/etc/mysql/my.cnf":
            source => [
                "puppet://$server/files/mysql/${fqdn}/my.cnf",
                "puppet://$server/files/mysql/my.cnf",
                "puppet://$server/mysql/my.cnf"
            ],
            ensure => file,
            owner => root,
            group => 0,
            mode => 0444,
            require => Package[mysql],
            notify => Service[mysql],
    }

	service { mysql:
		ensure => running,
		hasstatus => true,
		require => Package[mysql],
	}

	munin::plugin {
		[mysql_bytes, mysql_queries, mysql_slowqueries, mysql_threads]:
	}

	# Collect all databases and users
	Mysql_database<<||>>
	Mysql_user<<||>>
	Mysql_grant<<||>>
}

class mysql::server::gentoo inherits mysql::server::base {
    Package[mysql] {
        category => 'dev-db',
    }
}
