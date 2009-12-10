class mysql::server {

    $mysql_moduledir = "${module_dir_path}/mysql"
    module_dir { ['mysql', 'mysql/server']: }
    
    case $operatingsystem {
      gentoo: { include mysql::server::gentoo }
      centos: { include mysql::server::centos }
      debian: { include mysql::server::debian }
      default: { include mysql::server::base }
    }
    
    if $use_munin {
      include mysql::munin
    }
    
    if $use_shorewall {
      include shorewall::rules::mysql
    }
}
