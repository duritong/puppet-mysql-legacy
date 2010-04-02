class mysql::server::cron::backup {

    $real_mysql_backup_dir = $mysql_backup_dir ? {
        '' => '/var/backups/mysql',
        default => $mysql_backup_dir,
    }

    file { 'mysql_backup_dir':
        path => $real_mysql_backup_dir,
        ensure => directory,
        owner => root, group => 0, mode => 0700,
    }

    cron { 'mysql_backup_cron':
        command => '/usr/bin/mysqldump --default-character-set=utf8 --all-databases --all --flush-logs --lock-tables --single-transaction | gzip > ${real_mysql_backup_dir}/mysqldump.sql.gz && chmod 600 ${real_mysql_backup_dir}/mysqldump.sql.gz',
        user => 'root',
        minute => 0,
        hour => 1,
        require => [ Exec['mysql_set_rootpw'], File['mysql_root_cnf'], File['mysql_backup_dir'] ],
   }
}
