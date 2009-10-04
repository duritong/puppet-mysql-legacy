class mysql::server {
    case $operatingsystem {
      gentoo: { include mysql::server::gentoo }
      centos: { include mysql::server::centos }
      default: { include mysql::server::base }
    }
    if $use_munin {
      include mysql::munin
    }
    if $use_shorewall {
      include shorewall::rules::mysql
    }
}
