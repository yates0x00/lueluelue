require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'
require 'json'

puts "== used to check if icon hash is correct"
puts FaviconTool.get_favicon_mmh3_hash ARGV[0]

