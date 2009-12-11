# manifests/server/munin/debian.pp

class mysql::server::munin::debian {
    munin::plugin {
        [mysql_bytes, mysql_queries, mysql_slowqueries, mysql_threads]:
            config => "user root\nenv.mysqlopts --defaults-file=/etc/mysql/debian.cnf",
            require => Package['mysql'],
    }
}
