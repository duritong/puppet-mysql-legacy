Facter.add("mysql_exists") do
    ENV["PATH"]="/bin:/sbin:/usr/bin:/usr/sbin"
    
    setcode do
        mysqlexists = system "which mysql >&/dev/null"
        ($?.exitstatus == 0).to_s
    end
end
