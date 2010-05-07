class mysql::server {

    include common::moduledir
    $mysql_moduledir = "${common::moduledir::module_dir_path}/mysql"
    module_dir { ['mysql', 'mysql/server']: }
    
    case $operatingsystem {
      gentoo: { include mysql::server::gentoo }
      centos: { include mysql::server::centos }
      debian: { include mysql::server::debian }
      default: { include mysql::server::base }
    }
    
    if $use_munin {
      case $operatingsystem {
        debian: { include mysql::server::munin::debian }
        default: { include mysql::server::munin::default }
      }
    }

    if $use_nagios {
      include mysql::server::nagios
    }

    if $use_shorewall {
      include shorewall::rules::mysql
    }
}
