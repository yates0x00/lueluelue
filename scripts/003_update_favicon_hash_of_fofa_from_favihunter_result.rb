ENV['RAILS_ENV'] = 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'

puts "=== 本脚本是单线程执行，不会使用delayed job"

Server.where('project_id = ? and level=1 and favicon_hash_of_fofa_result like ?', ARGV[0], '%MMH3%').each do |server|
  favicon_hash_of_fofa = server.favicon_hash_of_fofa_result.gsub(/\e\[\d+m/, '').split("\n").select{ |e| e.include?("[MMH3]")}.first.split(' ').last rescue nil
  server.update favicon_hash_of_fofa: favicon_hash_of_fofa
end

puts "== done"

