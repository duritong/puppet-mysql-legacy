class mysql::server::cron::backup {

    $real_mysql_backup_dir = $mysql_backup_dir ? {
        '' => '/var/backups/mysql',
        default => $mysql_backup_dir,
    }

    case $mysql_manage_backup_dir {
      false: { info("We don't manage \$mysql_backup_dir ($mysql_backup_dir)") }
      default: {
        file { 'mysql_backup_dir':
          path => $real_mysql_backup_dir,
          ensure => directory,
          before => Cron['mysql_backup_cron'],
          owner => root, group => 0, mode => 0700;
        }
      }
    }

    cron { 'mysql_backup_cron':
        command => "/usr/bin/mysqldump --default-character-set=utf8 --all-databases --create-options --flush-logs --lock-tables --single-transaction | gzip > ${real_mysql_backup_dir}/mysqldump.sql.gz && chmod 600 ${real_mysql_backup_dir}/mysqldump.sql.gz",
        user => 'root',
        minute => 0,
        hour => 1,
        require => [ Exec['mysql_set_rootpw'], File['mysql_root_cnf'] ],
   }
}
