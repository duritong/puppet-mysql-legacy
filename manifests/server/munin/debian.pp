# manifests/server/munin/debian.pp

class mysql::server::munin::debian inherits mysql::server::munin::base {
  munin::plugin {
        [ mysql_bytes, mysql_queries, mysql_slowqueries, mysql_threads ]:
          config => "user root\nenv.mysqlopts --defaults-file=/etc/mysql/debian.cnf",
          require => Package['mysql'];
        
        [ mysql_connections, mysql_qcache, mysql_cache_mem, mysql_size_all ]:
          config => "user root\nenv.mysqlopts --defaults-file=/etc/mysql/debian.cnf",
          script_path_in => "/usr/local/share/munin-plugins",
          require => Package['mysql'];
  }
}
