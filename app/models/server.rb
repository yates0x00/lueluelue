class Server < ApplicationRecord
  has_many :ip_mappings
  has_many :ips, through: :ip_mappings
  has_many :emails
  belongs_to :project, optional: true

  after_create :create_related_jobs

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
    return temp[0,2000]
  end

  # 更新相关的FOFA计数，计算并更新subdomain_total_count_of_fofa_result字段
  def update_related_fofa_count
    total_count = (subdomain_count_main_domain_of_fofa_result || 0) + 
                  (subdomain_count_base_name_of_fofa_result || 0) + 
                  (subdomain_count_favicon_of_fofa_result || 0)
    update(subdomain_total_count_of_fofa_result: total_count)
  end

  def remove_ansi_color string
    return if string.blank?
    string.gsub("[0m]", '').gsub('[96m', '').gsub('[92m', '').gsub('[34m','').gsub('[94m', '')
  end

  def create_related_jobs
    #create_dig_job

    #create_wafwoof_job
    #create_the_harvester_job
    #create_ehole_job

    #create_nmap_job , depends on wafwoof result
    #create_wappalyzer_job
    #create_dirsearch_job
  end

  private
  def create_wafwoof_job
    command = "wafw00f #{self.name}"
    RunJob.set(priority: 100).perform_later command: command, result_column: 'wafwoof_result',
      is_detected_by_column: 'is_detected_by_wafwoof',
      entity: self
  end

  def create_the_harvester_job
    #command = "cd /workspace/coding_tools/theHarvester && python3 theHarvester.py -d #{self.name} -b all -p"
    command = "cd /opt/app/theHarvester && uv run theHarvester -d #{self.name} -b all -p --limit 50"
    Rails.logger.info "== in create_the_harvester_job, command: #{command}"
    RunJob.set(priority: 10).perform_later command: command, result_column: 'the_harvester_result',
      is_detected_by_column: 'is_detected_by_the_harvester',
      entity: self
  end

  def create_dig_job
    command = "dig +short #{self.name}"

    RunJob.set(priority: 0).perform_later command: command, result_column: 'dig_result',
      is_detected_by_column: 'is_detected_by_dig',
      entity: self
  end


  def create_wappalyzer_job
    #RunWappalyzerJob.perform_later url: self.name, server: self
  end

  def create_ehole_job
    RunEholeJob.set(priority: 5).perform_later server: self
  end

  #def create_dirsearch_job

  #  result_file = File.join(Rails.root, "dirsearch_result_folder", self.name)
  #  proxy = 'socks5://192.168.0.110:1075'
  #  max_rate = 20
  #  command = "python3 /workspace/coding_tools/dirsearch/dirsearch.py -u #{self.name} -o #{result_file} --proxy=#{proxy} --max-rate=#{max_rate} --no-color --quiet-mode"

  #  RunDirsearchJob.perform_later command: command, result_column: 'dirsearch_result',
  #    is_detected_by_column: 'is_detected_by_dirsearch',
  #    proxy: 'socks://192.168.0.100:1075',
  #    max_rate: 20,
  #    result_file: result_file,
  #    entity: self
  #end
end
