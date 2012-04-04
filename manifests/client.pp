class mysql::client ( $use_shorewall = hiera('use_shorewall',false) {

  case $::operatingsystem {
    debian: { include mysql::client::debian }
    default: { include mysql::client::base }
  }

  if $use_shorewall {
    include shorewall::rules::out::mysql
  }
  
}
