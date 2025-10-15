class RunFofaSubdomainJob < ApplicationJob
  queue_as :default

  def perform(options = {})
    server = options[:server]
    Rails.logger.info "== options: #{options.inspect}"

    # 如果是ip地址，啥也不做
    if ipv4_address?(server.name)
      Rails.logger.warn "=== server.name is ip address. return"
      return 
    end

    # 目前这些应该都了，以后有需要再增加step4..吧。
    query_strings = []
    query_strings << %Q{host=".#{server.name}"} if server.is_to_query_fofa_by_main_domain
    query_strings << %Q{domain*="*.#{server.name.split('.')[0]}.*"} if server.is_to_query_fofa_by_base_name
    query_strings << %Q{icon_hash="#{server.favicon_hash_of_fofa}"} if server.is_to_query_fofa_by_icon_hash

    FofaTool.new.query query_string: query_strings.join(' || '), server: server
  end

  private
  def get_icon_hash server

    Rails.logger.info "== getting icon_hash of #{server.name}, raw result: #{server.favicon_hash_of_fofa_result}"

    # ["\t[MMH3] -462799784", "\t[FOFA][MMH3] https://is.gd/dQU8tF", "\t[Shodan][MMH3] https://is.gd/SAvBr3", "\t[Silent Push][MMH3] https://is.gd/ARMmCv", "\t[Zoomeye][MMH3] https://is.gd/gQhEMK"]
    result = server.favicon_hash_of_fofa_result.gsub(/\e\[\d+m/, '').split("\n").select{ |e| e.include?("[MMH3]")}.first.split(' ').last rescue nil
    
    Rails.logger.info "== icon_hash of #{server.name}: |#{result}|"
    
    return result
  end

  def ipv4_address?(str)
    str.match?(/^\d+\.\d+\.\d+\.\d+$/)
  end

end
