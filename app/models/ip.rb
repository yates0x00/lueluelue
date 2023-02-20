class Ip < ApplicationRecord
  has_many :ip_mappings
  has_many :servers, :through => :ip_mappings

  def short_text_for_nmap_result
    return '-' if nmap_result.blank?
    temp = nmap_result.split("\n").select{|str| str.include?('open')}
    if temp.blank?
      temp = '-'
    else
      temp = temp.join("<br/>")
    end
    return temp
  end
end
