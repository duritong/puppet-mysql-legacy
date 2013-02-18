# Helpers for mysql servers
# In a dedicated class so they can
# also be pulled in somewhere else
class mysql::server::backup_helpers{
  file{'/usr/local/bin/mysql_extract_from_backup':
    source  => 'puppet:///modules/mysql/backup_helpers/mysql_extract_from_backup.sh',
    owner   => root,
    group   => 0,
    mode    => '0555';
  }
}
