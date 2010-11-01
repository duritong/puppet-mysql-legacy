class mysql::server::munin::base {

  file {
    "/usr/local/share/munin-plugins/mysql_connections":
      source => "puppet:///modules/mysql/munin/mysql_connections",
      mode => 0755, owner => root, group => root;

    "/usr/local/share/munin-plugins/mysql_qcache":
      source => "puppet:///modules/mysql/munin/mysql_qcache",
      mode => 0755, owner => root, group => root;

    "/usr/local/share/munin-plugins/mysql_qcache_mem":
      source => "puppet:///modules/mysql/munin/mysql_qcache_mem",
      mode => 0755, owner => root, group => root;

    "/usr/local/share/munin-plugins/mysql_size_all":
      source => "puppet:///modules/mysql/munin/mysql_size_all",
      mode => 0755, owner => root, group => root;
  }
}
