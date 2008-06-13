# manifests/selinux.pp

class mysql::selinux {
    case $operatingsystem {
        gentoo: { include mysql::selinux::gentoo }
    }
}

class mysql::selinux::gentoo {
    package{'selinux-mysql':
        ensure => present,
        category => 'sec-policy',
        require => Package[mysql],
    }
    selinux::loadmodule {'mysql': }
}
