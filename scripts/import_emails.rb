ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

emails = %w{
abuse@nextcloud.com
admin@nextcloud.com
administrator@nextcloud.com
alvaro.brey@nextcloud.com
android@nextcloud.com
anonymous@nextcloud.com
arthur.schiwon@nextcloud.com
arthur@nextcloud.com
bjoern@nextcloud.com
bjorn@nextcloud.com
bjornschiessle@nextcloud.com
bot@nextcloud.com
camila@nextcloud.com
dreeves@nextcloud.com
events@nextcloud.com
felix.weilbach@nextcloud.com
frank.karlitschek@nextcloud.com
frank@nextcloud.com
google@nextcloud.com
https://nextcloud.com/media/top-banner@2x.png
info@nextcloud.com
ivan@nextcloud.com
jobs@nextcloud.com
jordanwakalski24@nextcloud.com
jos.poortvliet@nextcloud.com
jos@nextcloud.com
lukas@nextcloud.com
maruthuu@nextcloud.com
mathias@nextcloud.com
max@nextcloud.com
maxence@nextcloud.com
niels.mache@nextcloud.com
nina@nextcloud.com
olivier.paroz@nextcloud.com
olivier@nextcloud.com
oparoz@nextcloud.com
paulo@nextcloud.com
robin@nextcloud.com
roeland@nextcloud.com
sales@nextcloud.com
sascha.wiswedel@nextcloud.com
tobias@nextcloud.com
vincent@nextcloud.com
webmaster@nextcloud.com
}

server = Server.find_by_name 'nextcloud.com'
emails.each do |email_text|
  Email.create server_id: server.id, address: email_text, project_id: server.project_id
end

