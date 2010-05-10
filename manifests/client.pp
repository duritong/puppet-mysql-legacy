class mysql::client {

  case $operatingsystem {
    debian: { include mysql::client::debian }
    default: { include mysql::client::base }
  }

  if $use_shorewall {
    include shorewall::rules::out::mysql
  }
  
}
