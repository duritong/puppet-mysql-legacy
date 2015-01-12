#!/usr/bin/env ruby

# set home as we runit as weekly cron, where HOME is /
ENV['HOME'] = '/root'
tables = %x{mysql -Bse "SELECT TABLE_SCHEMA,TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA NOT IN ('information_schema','mysql') AND Data_free > 0 AND ENGINE IN ('MyISAM','InnoDB','ARCHIVE')"}
tables.split("\n").each do |table|
  tableitems = table.chomp.split(/\t/)
  output = %x{mysql #{tableitems[0]} -Bse "OPTIMIZE TABLE \\`#{tableitems[0]}\\`.\\`#{tableitems[1]}\\`"  2>&1}
  unless output =~ /status\t+OK/
    puts "Error while optimizing #{tableitems[0]}.#{tableitems[1]}:"
    puts output
    puts
  end
end
