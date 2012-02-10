class mysql::server {

    case $::operatingsystem {
      gentoo: { include mysql::server::gentoo }
      centos: { include mysql::server::centos }
      debian: { include mysql::server::debian }
      default: { include mysql::server::base }
    }

    if hiera('use_munin',false) {
      case $::operatingsystem {
        debian: { include mysql::server::munin::debian }
        default: { include mysql::server::munin::default }
      }
    }

    if hiera('use_nagios',false) {
      case hiera('nagios_check_mysql',false) {
        false: { info("We don't do nagioschecks for mysql on ${::fqdn}" ) }
        default: { include mysql::server::nagios }
      }
    }

    if hiera('use_shorewall',false) {
      include shorewall::rules::mysql
    }
}
