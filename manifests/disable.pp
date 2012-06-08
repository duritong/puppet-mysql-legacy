# manifests/disable.pp

# class to install mysql-server
# in a disabled way.
class mysql::disable {
  package{'mysql-server':
    ensure => installed,
  }

  service {mysql:
    ensure => stopped,
    enable => false,
    hasstatus => true,
    require => Package['mysql-server'],
  }
}
