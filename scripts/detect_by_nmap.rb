ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'


# 1. model   app/models/csv_record.rb
#    这么多列：  che_pai, name, entered_at , leaved_at


# 2. 分析
CsvRecord.write_result_to_csv
