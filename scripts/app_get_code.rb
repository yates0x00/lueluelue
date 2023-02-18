ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'development'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'


def perform_request i
  url = "https://prd.biophysics.beiersdorf.com/v2/study/consents?studyNumber=#{i}"
  response = HTTParty.get url
  puts "== calling: #{url}, response.code: #{response.code}"
  if response.code != 404
    puts "==!!! not 404!!!"
    puts response.code
  end
end

(0..1000000).each do |i|
  perform_request format('%05d', i)
end

puts "done"

