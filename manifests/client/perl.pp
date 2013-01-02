# mysql perl config
class mysql::client::perl {
  case $::operatingsystem {
    debian: { include mysql::client::perl::debian }
  }
}
