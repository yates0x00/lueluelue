class Project < ApplicationRecord
  has_many :servers
  has_many :emails
  has_many :c_class_networks

  def ips_not_behind_waf
    result = []
    servers.includes(:ips).where('is_confirmed_not_behind_waf = 1 and level <= 3').find_each do |server|
      server.ips.each do |ip_entity|
        result << ip_entity
      end
    end
    return result.sort_by { |ip_entity| ip_entity.ip }
  end
end
