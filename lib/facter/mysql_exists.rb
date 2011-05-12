Facter.add("mysql_exists") do
    setcode do
        File.exist? '/usr/bin/mysql'
    end
end
