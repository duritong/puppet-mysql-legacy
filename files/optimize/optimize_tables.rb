#!/usr/bin/env ruby

tables = %x{mysql -Bse "SELECT TABLE_SCHEMA,TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA NOT IN ('information_schema','mysql') AND Data_free > 0 AND ENGINE IN ('MyISAM','InnoDB','ARCHIVE')"}
tables.each { |table|
    tableitems = table.chomp.split(/\t/)
    system "mysql #{tableitems[0]} -Bse \"OPTIMIZE TABLE #{tableitems[1]}\" | grep -q OK"
    if $?.to_I > 0 then
        puts "error while optimizing #{tableitems[0]}. #{tableitems[1]}"
    end
}
