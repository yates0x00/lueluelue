ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'production'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

require 'csv'

comment = "from nextcloud.com, from shuize"
sites = %w{
sentry.nextcloud.com
filemi.nextcloud.com
docs.nextcloud.com
drone-worker1.nextcloud.com
customerpush.nextcloud.com
s1.nextcloud.com
ci-assets.nextcloud.com
odoo.nextcloud.com
apps.nextcloud.com
scan.nextcloud.com
tech-preview.nextcloud.com
monitoring.nextcloud.com
dynamic38.nextcloud.com
aio-testing.nextcloud.com
lists.nextcloud.com
reserveproxy.nextcloud.com
transifex-sync.nextcloud.com
stats.nextcloud.com
xmpp.nextcloud.com
services.nextcloud.com
collabora.services.nextcloud.com
auth.nextcloud.com
c0005.customerpush.nextcloud.com
cloud-old.nextcloud.com
sermo.nextcloud.com
collabora-test.nextcloud.com
projects.nextcloud.com
cloud.nextcloud.com
demo2.nextcloud.com
support.nextcloud.com
testing.nextcloud.com
www.nextcloud.com
perftesting.nextcloud.com
gaia-x.nextcloud.com
stun.nextcloud.com
turn.nextcloud.com
host-21.nextcloud.com
notifications.nextcloud.com
newsletter.nextcloud.com
help.nextcloud.com
collabora.nextcloud.com
drone-worker2.nextcloud.com
portal.nextcloud.com
download.nextcloud.com
demo.nextcloud.com
crm.nextcloud.com
collabora-test2.nextcloud.com
surveyserver.nextcloud.com
0-198.nextcloud.com
push-notifications.nextcloud.com
knowledge.nextcloud.com
mautic.nextcloud.com
nebula.nextcloud.com
conf.nextcloud.com
00742b3530.nextcloud.com
s4.nextcloud.com
drone.nextcloud.com
lookup.nextcloud.com
example.nextcloud.com
antitrust.nextcloud.com
mx.nextcloud.com
ldap.nextcloud.com
conference.nextcloud.com
211newsletter.nextcloud.com
staging.nextcloud.com
demo-push-notifications.nextcloud.com
handbook.nextcloud.com
backport.bots.nextcloud.com
pushfeed.nextcloud.com
usercontent.apps.nextcloud.com
customerupdates.nextcloud.com
pilvi.nextcloud.com
go.nextcloud.com
try.nextcloud.com
s5.nextcloud.com
demo1.nextcloud.com
s2.nextcloud.com
updates.nextcloud.com
dyoder.nextcloud.com
10265d6d9579112530.nextcloud.com
logs.nextcloud.com
dynamic4.nextcloud.com
10216.nextcloud.com
007zhenrenduchang.nextcloud.com
101-62.nextcloud.com
web2.nextcloud.com
static.apps.nextcloud.com
duchangmenpiao.nextcloud.com
portal2.nextcloud.com

}


def get_ip_by_domains sites
  result = []
  sites.each_slice(20) do |sites_in_20|

    threads = []
    sites_in_20.each do |site|
      threads << Thread.new do
        puts "site: #{site}"
        server = Server.where("name = ?", site).first
        if server.blank?
          server = Server.create name: site, comment: comment
        end

        command = "dig +short #{site}"
        dig_result = `#{command}`

        Rails.logger.info "== command: #{command}, result: #{dig_result}"

        server.dig_result = dig_result
        server.save!
      end
    end
    threads.each {|t| t.join}

    sleep 5
  end
end

def get_wafw00f_result_by_domains sites
  sites.each_slice(20) do |sites_in_20|

    threads = []
    sites_in_20.each do |site|
      threads << Thread.new do
        puts "site: #{site}, index: #{sites.index(site)}"
        server = Server.where("name = ?", site).first
        if server.blank?
          server = Server.create name: site
        end

        command = "wafw00f #{site}"
        result = `#{command}`
        Rails.logger.info "== command: #{command}, result: #{result}"

        server.wafwoof_result = result
        server.save!
      end
    end
  end
end

get_ip_by_domains sites
