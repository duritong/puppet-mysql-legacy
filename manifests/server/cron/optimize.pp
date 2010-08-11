class mysql::server::cron::optimize {

   file { 'mysql_optimize_script':
       path => '/usr/local/sbin/optimize_mysql_tables.rb',
       source => "puppet:///modules/mysql/scripts/optimize_tables.rb",
       owner => root, group => 0, mode => 0700;
   }

    cron { 'mysql_optimize_cron':
        command => '/usr/local/sbin/optimize_mysql_tables.rb',
        user => 'root',
        minute => 40,
        hour => 6,
        weekday => 7,
        require => [ Exec['mysql_set_rootpw'], File['mysql_root_cnf'], File['mysql_optimize_script'] ],
   }

}
