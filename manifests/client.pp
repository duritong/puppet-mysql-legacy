class mysql::client {
  package{mysql:
    ensure => present,
  }
  if $use_shorewall {
    include shorewall::rules::out::mysql
  }
}
