# manage a mysql server
class mysql::server (
  $root_password,
  $manage_shorewall     = false,
  $manage_munin         = false,
  $munin_password       = 'absent',
  $manage_nagios        = false,
  $nagios_password_hash = 'absent',
  $backup_cron          = false,
  $optimize_cron        = false,
  $backup_dir           = '/var/backups/mysql',
  $manage_backup_dir    = true,
  $nagios_notcp         = false
) {
  case $::operatingsystem {
    gentoo:  { include mysql::server::gentoo }
    centos:  { include mysql::server::centos }
    debian:  { include mysql::server::debian }
    default: { include mysql::server::base }
  }

  if $manage_munin and $::mysql_exists == 'true' {
    if $munin_password == 'absent' {
      fail('need to set the munin password')
    }
    case $::operatingsystem {
      debian:  { include mysql::server::munin::debian }
      default: { include mysql::server::munin::default }
    }
  }

  if $manage_nagios and $::mysql_exists == 'true' {
    if $nagios_password_hash == 'absent' {
      fail('need to set the nagios password hash')
    }
    include mysql::server::nagios
  }

  if $manage_shorewall {
    include shorewall::rules::mysql
  }
}
