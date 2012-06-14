class mysql::server (
  $manage_shorewall = false,
  $manage_munin     = false,
  $manage_nagios    = false
) {
  case $::operatingsystem {
    gentoo:  { include mysql::server::gentoo }
    centos:  { include mysql::server::centos }
    debian:  { include mysql::server::debian }
    default: { include mysql::server::base }
  }

  if $manage_munin {
    case $::operatingsystem {
      debian:  { include mysql::server::munin::debian }
      default: { include mysql::server::munin::default }
    }
  }

  if $manage_nagios {
    include mysql::server::nagios
  } 

  if $manage_shorewall {
    include shorewall::rules::mysql
  }
}
