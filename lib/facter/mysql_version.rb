Facter.add("mysql_version") do
  setcode do
    Facter::Util::Resolution.exec('mysql --version').chomp.split(' ')[4].split(',').first
  end
end
