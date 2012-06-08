class mysql::client::ruby {

  case $::operatingsystem {
    debian: { include mysql::client::ruby::debian }
  }

}
