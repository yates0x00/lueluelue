class RunFofaSubdomainCountJob < ApplicationJob
  queue_as :default

  def perform(options = {})
    server = options[:server]
    Rails.logger.info "== options: #{options.inspect}"

    # 如果是ip地址，啥也不做
    if ipv4_address?(server.name)
      Rails.logger.warn "=== server.name is ip address. return"
      return 
    end

    fofa_tool = FofaTool.new

    # 例如, domain = main.com
    # step1. 根据 "main.com" 来搜索
    fofa_tool.query_count query_string: %Q{"#{server.name}"}, server: server

    # step2. 根据 "*.main.*" 来搜索
    middle_domain_name =  server.name.split('.')[0]
    if middle_domain_name.size > 6 && server.name.count('.') == 1 
      fofa_tool.query_count query_string: %Q{domain*="*.#{middle_domain_name}.*"}, server: server
    end

    # step3. 根据 主域名的favicon来搜索，如果对应的server存在的话
    icon_hash = get_icon_hash server
    if icon_hash.present? && server.level == 1
      fofa_tool.query_count query_string: %Q{icon_hash="#{icon_hash}"}, server: server
    end

    # 目前这些应该都了，以后有需要再增加step4..吧。
    server.update subdomain_total_count_of_fofa_result: (server.subdomain_count_base_name_of_fofa_result || 0) + (server.subdomain_count_favicon_of_fofa_result || 0) + (server.subdomain_count_main_domain_of_fofa_result || 0)
  end

  private
  def get_icon_hash server

    Rails.logger.info "== getting icon_hash of #{server.name}, raw result: #{server.favicon_hash_of_fofa_result}"

    # ["\t[MMH3] -462799784", "\t[FOFA][MMH3] https://is.gd/dQU8tF", "\t[Shodan][MMH3] https://is.gd/SAvBr3", "\t[Silent Push][MMH3] https://is.gd/ARMmCv", "\t[Zoomeye][MMH3] https://is.gd/gQhEMK"]
    return server.favicon_hash_of_fofa_result.gsub(/\e\[\d+m/, '').split("\n").select{ |e| e.include?("[MMH3]")}.first.split(' ').last rescue nil
  end

  def ipv4_address?(str)
    str.match?(/^\d+\.\d+\.\d+\.\d+$/)
  end

end
