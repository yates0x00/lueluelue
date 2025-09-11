ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'


a = %Q{                \e[1;97m______               \e[1;97m/      \\              \e[1;97m(  W00f! )               \e[1;97m\\  ____/               \e[1;97
m,,    \e[1;92m__            \e[1;93m404 Hack Not Found           \e[1;96m|`-.__   \e[1;92m/ /                     \e[1;91m __     __           \e[1;96m/\"  _/  \e[1;92m/_/
                       \e[1;91m\\ \\   / /          \e[1;94m*===*    \e[1;92m/                          \e[1;91m\\ \\_/ /  \e[1;93m405 Not Allowed         \e[1;96m/     )__
//                           \e[1;91m\\   /    \e[1;96m/|  /     /---`                        \e[1;93m403 Forbidden    \e[1;96m\\\\/`   \\ |
 \e[1;91m/ _ \\    \e[1;96m`\\    /_\\\\_              \e[1;93m502 Bad Gateway  \e[1;91m/ / \\ \\  \e[1;93m500 Internal Error      \e[1;96m`_____``-`
      \e[1;91m/_/   \\_\\                        \e[1;96m~ WAFW00F : \e[1;94mv2.2.0 ~\e[1;97m        The Web Application Firewall Fingerprinting Toolkit    \e[0m[*]}

Server.where('id > ?', 10230).each {|server|
  if server.wafwoof_result.present? && server.wafwoof_result.include?("Checking")
    wafwoof_result = server.wafwoof_result.split("Checking").last
    puts "ok, wafwoof_result: #{wafwoof_result}"
    server.update wafwoof_result: wafwoof_result
  end
}

puts "done"
