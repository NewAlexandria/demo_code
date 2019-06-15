#!/usr/bin/sh ruby

load 'parse/sectioner.rb'
load 'parse/identities.rb'

Sectioner.new  filename:"sample_data_1.txt"
Sectioner.new  filename:"sample_data_2.txt"
Sectioner.new  filename:"sample_data_3.txt"
Identities.new filename:"sample_data_1_sectioner.csv"
Identities.new filename:"sample_data_2_sectioner.csv"
Identities.new filename:"sample_data_3_sectioner.csv"

puts "Done with export.  Look for *_identities* CSV files"
