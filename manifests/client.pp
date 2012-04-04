class mysql::client {

  case $::operatingsystem {
    debian: { include mysql::client::debian }
    default: { include mysql::client::base }
  }

  if hiera('use_shorewall',false) {
    include shorewall::rules::out::mysql
  }

}
