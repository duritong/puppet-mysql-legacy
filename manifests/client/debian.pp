# debian client name
class mysql::client::debian inherits mysql::client::base {
  Package['mysql'] {
    name => 'mysql-client',
  }
}
