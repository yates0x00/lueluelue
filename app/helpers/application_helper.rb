module ApplicationHelper
  def short_text_for_nmap_result nmap_result
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
