# setup a basic cronjob to backup mysql database
class mysql::server::cron::backup {
  if $mysql::server::manage_backup_dir {
    file { 'mysql_backup_dir':
      ensure  => directory,
      path    => $mysql::server::backup_dir,
      before  => Cron['mysql_backup_cron'],
      owner   => root,
      group   => 0,
      mode    => '0700';
    }
  }

  if versioncmp($::mysql_version,'5.1.68') > 0 {
    $backup_command = "/usr/bin/mysqldump --default-character-set=utf8 --all-databases --create-options --flush-logs --lock-tables --single-transaction --events --ignore-table=mysql.event | gzip > ${mysql::server::backup_dir}/mysqldump.sql.gz && chmod 600 ${mysql::server::backup_dir}/mysqldump.sql.gz"
  } else {
    $backup_command = "/usr/bin/mysqldump --default-character-set=utf8 --all-databases --create-options --flush-logs --lock-tables --single-transaction | gzip > ${mysql::server::backup_dir}/mysqldump.sql.gz && chmod 600 ${mysql::server::backup_dir}/mysqldump.sql.gz"
  }

  cron { 'mysql_backup_cron':
    command => $backup_command,
    user    => 'root',
    minute  => 0,
    hour    => 1,
    require => [ Exec['mysql_set_rootpw'], File['mysql_root_cnf'] ],
  }
}
