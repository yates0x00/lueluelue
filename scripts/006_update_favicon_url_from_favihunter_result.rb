require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'

def run servers
  servers.each do |server|
    favicon_url = server.favicon_hash_of_fofa_result.match(/Favicon (http.*) downloaded/)[1]
    puts "== favicon_url: #{favicon_url}"
    begin
      server.update favicon_url: favicon_url
    rescue Exception => e
      puts "== error: #{e.inspect}"
    end
  end
end


servers = Server.where('project_id = ? and level = 1 and favicon_hash_of_fofa_result like "%downloaded%"', ARGV[0])
run servers
