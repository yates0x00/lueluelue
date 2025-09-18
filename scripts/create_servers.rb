ENV['RAILS_ENV'] = 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'
require 'csv'

puts "=== ruby scripts/create_servers wordpress_20w.txt 2"

# 数据量大的话，就使用本脚本批量导入数据，例如导入1W个
COMMENT = "world press 20w, CN region"

file = File.read ARGV[0]
project_id = ARGV[1]

line_count = 0
file.each_line do |line|
  line_count += 1
  Rails.logger.info "Processing line #{line_count}: #{line}" if line_count % 100 == 0  # 每100行输出一次进度

  info = line.split('://')
  protocal = info[0]
  name = info[1]
  Server.create name: name, protocal: protocal

  Rails.logger.info "Created server #{line_count}: #{name}" if line_count % 1000 == 0  # 每1000行输出一次创建信息
end

Rails.logger.info "== Finished processing #{line_count} lines."


