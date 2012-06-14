class mysql::client (
  $manage_shorewall = false
) {

  case $::operatingsystem {
    debian: { include mysql::client::debian }
    default: { include mysql::client::base }
  }

  if $manage_shorewall {
    include shorewall::rules::out::mysql
  }

}
