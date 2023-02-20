class Server < ApplicationRecord
  has_many :ip_mappings
  has_many :ips, through: :ip_mappings

  def short_text_for_wappalyzer_result
    return '-' if wappalyzer_result.blank?
    temp = wappalyzer_result
    if temp.include?("https is not available")
      temp = wappalyzer_result.gsub("https is not available, <br/>", "")
    end
    return JSON.parse(temp)['technologies'].map { |e| e['name']}.join("<br/>")
  end


  def short_text_for_the_harvester_result
    return '-' if the_harvester_result.blank?
    temp = the_harvester_result.split('Searching Sublist3r').last
    return '-' if temp.blank?
    #temp = (temp).gsub("\n", "<br/>")
    return temp
  end

  def remove_ansi_color string
    return if string.blank?
    string.gsub("[0m]", '').gsub('[96m', '').gsub('[92m', '').gsub('[34m','').gsub('[94m', '')
  end
end
