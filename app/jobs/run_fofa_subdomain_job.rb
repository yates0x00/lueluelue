class RunFofaSubdomainJob < ApplicationJob
  queue_as :default

  # options:
  # domain: 要查询的主域名
  # search_strategy: 搜索策略
  # server: Server对象（可选，用于更新状态）
  def perform(options = {})
    server = options[:server]
    Rails.logger.info "== options: #{options.inspect}"
    fofa_tool = FofaTool.new

    # 例如, domain = main.com
    # step1. 根据 "main.com" 来搜索
    fofa_tool.query query_string: %Q{"#{server.name}"}, server: server

    # step2. 根据 "*.main.*" 来搜索
    fofa_tool.query query_string: %Q{domain*="*.#{server.name.split('.')[0]}.*"}, server: server
#
#    # step3. 根据 主域名的favicon来搜索，如果对应的server存在的话
#    icon_hash = get_icon_hash server.favicon_hash_of_fofa_result
#    if icon_hash.present?
#      fofa_tool.query %Q{icon_hash="#{icon_hash}"}, server: server
#    end
  end

  private

end
