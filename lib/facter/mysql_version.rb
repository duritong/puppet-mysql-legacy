Facter.add("mysql_version") do
    confine :mysql_exists => true
    setcode do
        Facter::Util::Resolution.exec('mysql --version').chomp.split(' ')[4]
    end
end
