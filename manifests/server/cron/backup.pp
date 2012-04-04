class mysql::server::cron::backup (
  $mysql_backup_dir = hiera('mysql_backup_dir','/var/backups/mysql'),
  $mysql_manage_backup_dir = hiera('mysql_manage_backup_dir',true)
) {
   case $mysql_manage_backup_dir {
     false: { info("We don't manage the mysql_backup_dir") }
     default: {
       file { 'mysql_backup_dir':
         path => $mysql_backup_dir,
         ensure => directory,
         before => Cron['mysql_backup_cron'],
         owner => root, group => 0, mode => 0700;
       }
     }
   }

   cron { 'mysql_backup_cron':
       command => "/usr/bin/mysqldump --default-character-set=utf8 --all-databases --all --flush-logs --lock-tables --single-transaction | gzip > ${mysql_backup_dir}/mysqldump.sql.gz && chmod 600 ${mysql_backup_dir}/mysqldump.sql.gz",
       user => 'root',
       minute => 0,
       hour => 1,
       require => [ Exec['mysql_set_rootpw'], File['mysql_root_cnf'] ],
   }
}
