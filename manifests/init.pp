#
# mysql module
#
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# Copyright 2008, admin(at)immerda.ch
# Copyright 2008, Puzzle ITC GmbH
# Marcel Härry haerry+puppet(at)puzzle.ch
# Simon Josi josi+puppet(at)puzzle.ch
#
# This program is free software; you can redistribute 
# it and/or modify it under the terms of the GNU 
# General Public License version 3 as published by 
# the Free Software Foundation.
#

# modules_dir { "mysql": }

class mysql::server {
    case $operatingsystem {
        gentoo: { include mysql::server::gentoo }
        centos: { include mysql::server::centos }
        default: { include mysql::server::base }
    }
    if $selinux {
        include mysql::selinux
    }
    if $use_munin {
        include mysql::munin
    }
}

class mysql::server::base {
    package { mysql-server:
        ensure => present,
    }
    file{'/etc/mysql/my.cnf':
            source => [
                "puppet://$server/files/mysql/${fqdn}/my.cnf",
                "puppet://$server/files/mysql/my.cnf",
                "puppet://$server/mysql/config/my.cnf.${operatingsystem}",
                "puppet://$server/mysql/config/my.cnf"
            ],
            ensure => file,
            require => Package[mysql-server],
            notify => Service[mysql],
            owner => root, group => 0, mode => 0644;
    }
    file{'/var/lib/mysql/data':
        ensure => directory,
        require => Package[mysql-server],
        before => File['/etc/mysql/my.cnf'],
        owner => mysql, group => mysql, mode => 0755;
    }

    file{'/var/lib/mysql/data/ibdata1':
        ensure => file,
        require => Package[mysql-server],
        before => File['/opt/bin/setmysqlpass.sh'],
        owner => mysql, group => mysql, mode => 0660;
    }

    case $mysql_rootpw {
        '': { fail("You need to define a mysql root password! Please set \$mysql_rootpw in your site.pp or host config") }
    }
    file{'/opt/bin/setmysqlpass.sh':
        source => "puppet://$server/mysql/config/${operatingsystem}/setmysqlpass.sh",
        require => Package[mysql-server],
        owner => root, group => 0, mode => 0500;
    }        
    file {'/root/.my.cnf':
        content => template('mysql/root/my.cnf.erb'),
        require => [ Package[mysql-server] ],
        owner => root, group => 0, mode => 0400;
    }
    exec{'set_mysql_rootpw':
        command => "/opt/bin/setmysqlpass.sh $mysql_rootpw",
        unless => "mysqladmin -uroot status > /dev/null",
        require => [ File['/opt/bin/setmysqlpass.sh'], Package[mysql-server] ],
    }
   file{'/etc/cron.d/mysql_backup.cron':
       source => [ "puppet://$server/mysql/backup/mysql_backup.cron.${operatingsystem}",
                   "puppet://$server/mysql/backup/mysql_backup.cron" ],
       require => [ Exec[set_mysql_rootpw], File['/root/.my.cnf'] ],
       owner => root, group => 0, mode => 0600;
   }
   file{'/etc/cron.weekly/mysql_optimize_tables.rb':
       source => "puppet://$server/mysql/optimize/optimize_tables.rb",
       require => [ Exec[set_mysql_rootpw], File['/root/.my.cnf'] ],
       owner => root, group => 0, mode => 0700;
   }
   service {mysql:
       ensure => running,
       enable => true,
       hasstatus => true,
       require => Package[mysql],
   }

  # Collect all databases and users
  Mysql_database<<| tag == "mysql_${fqdn}" |>>
  Mysql_user<<| tag == "mysql_${fqdn}"  |>>
  Mysql_grant<<| tag == "mysql_${fqdn}" |>>
}

class mysql::server::gentoo inherits mysql::server::base {
    Package[mysql-server] {
        alias => 'mysql',
        category => 'dev-db',
    }
}

class mysql::server::clientpackage inherits mysql::server::base {
    package{mysql:
        ensure => present,
    }
    File['/opt/bin/setmysqlpass.sh']{
        require +> Package[mysql],
    }
    File['/root/.my.cnf']{
        require +> Package[mysql],
    }
    Exec['set_mysql_rootpw']{
        require +> Package[mysql],
    }
    File['/etc/cron.d/mysql_backup.cron']{
        require +> Package[mysql],
    }
}

class mysql::server::centos inherits mysql::server::clientpackage {
    Service[mysql]{
        name  => 'mysqld',
    }
    File['/etc/mysql/my.cnf']{
        path => '/etc/my.cnf',
    }
	
}
