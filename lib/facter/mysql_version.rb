Facter.add("mysql_version") do
  setcode do
    if s = Facter::Util::Resolution.exec('mysql --version')
      s.chomp.split(' ')[4].split(',').first
    end
  end
end
