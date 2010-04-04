#!/usr/bin/env ruby

# set home as we runit as weekly cron, where HOME is /
ENV['HOME'] = '/root'
tables = %x{mysql -Bse "SELECT TABLE_SCHEMA,TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA NOT IN ('information_schema','mysql') AND Data_free > 0 AND ENGINE IN ('MyISAM','InnoDB','ARCHIVE')"}
tables.each { |table|
    tableitems = table.chomp.split(/\t/)
    system "mysql #{tableitems[0]} -Bse \"OPTIMIZE TABLE \\`#{tableitems[0]}\\`.\\`#{tableitems[1]}\\`\" | grep -q OK"
    if $?.to_i > 0 then
        puts "error while optimizing #{tableitems[0]}.#{tableitems[1]}"
    end
}
