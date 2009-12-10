class mysql::client {
  package{mysql:
    name => $operatingsystem ? {
        'debian' => 'mysql-client',
        default => 'mysql',
    },
    alias => 'mysql',
    ensure => present,
  }
  if $use_shorewall {
    include shorewall::rules::out::mysql
  }
}
