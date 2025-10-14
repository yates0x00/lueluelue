require 'json'
require 'open3'

class FofaTool
  #"domain*=\\\"*.#{domain}.*\\\""
  #"\\\"#{domain}\\\""
  #"title=\\\"#{domain}\\\""
  #"icon_hash=\\\"#{domain}\\\""
  #"title=\\\"#{domain}\\\" || desc=\\\"#{domain}\\\" || body=\\\"#{domain}\\\" || domain*=\\\"*.#{domain}.*\\\""

  def initialize
    # FOFA API配置
    @api_key = ENV['FOFA_API_KEY']
    @url = "https://fofa.info/api/v1/search/all"
  end

  def query(options)
    Rails.logger.info "== in query, options:#{options.inspect}"
    server = options[:server]
    query_string = options[:query_string]

    # 根据搜索策略构建查询语句
    Rails.logger.info "== FOFA query: #{query_string}"

    # 编码查询语句
    encoded_query = Base64.strict_encode64(query_string)
    Rails.logger.info "== FOFA encoded_query : #{encoded_query}"

    # API请求参数
    base_params = {
      key: @api_key,
      qbase64: encoded_query,
      size: 100,
      #fields: "host,ip,port,protocol,title,domain,country,country_name,city,link,org,banner,asn,org,isp"
      fields: "host,protocol,title"
    }

    results = []
    page = 1

    begin
      loop do
        # 合并当前页码到参数中
        params = base_params.merge(page: page)

        # 构建curl命令
        query_string_parts = params.map { |k, v| "#{k}=#{v}" }.join('&')
        full_url = "#{@url}?#{query_string_parts}"

        # 使用curl命令发送请求
        curl_command = "curl -s \"#{full_url}\""
        Rails.logger.info "== FOFA curl_command: #{curl_command}"

        stdout, stderr, status = Open3.capture3(curl_command)

        # 检查curl命令是否成功执行
        unless status.success?
          Rails.logger.error "== curl命令执行失败: stderr: #{stderr}, stdout: #{stdout}, status: #{status}"
          break
        end

        # 解析JSON响应
        data = JSON.parse(stdout)

        if data["error"]
          Rails.logger.error "FOFA查询错误: #{data}"
          break
        end

        # 收集结果
        results.concat(data["results"] || [])
        Rails.logger.info "已获取 #{results.length} 条结果，当前页码: #{page}"

        # 检查是否还有更多页
        if (data["results"] || []).length < params[:size] || page >= (data["page_total"] || 100)
          break
        end

        page += 1

        if page == 20
          Rails.logger.warn "===== max page? 这个是不是有问题？怎么有50页？暂时退出"
          break
        end

        # 添加延迟避免请求过于频繁
        sleep(1)
      end

      # 处理结果并保存到Server表
      process_and_save_results(results,  server)

      # 更新服务器状态（如果提供了server对象）
      if server
        server.update(
          is_detected_by_fofa: true,
          favicon_hash_of_fofa_result: "Found #{results.length} subdomains, will be saved to servers"
        )
      end

      Rails.logger.info "查询完成，共获取 #{results.length} 条结果"
      results

    rescue => e
      Rails.logger.error e
      Rails.logger.error e.backtrace.join("\n")

      raise # 触发重试机制
    end
  end

  def process_and_save_results(results, server = nil)
    return if results.blank?

    # fields: "host,ip,port,protocol,title,domain,country,country_name,city,link,org,banner,asn,org,isp"
    # result: ["zzxsp.cn", "38.181.13.145", "80", "http", "长沙附近约 大学生快餐 100/200/300/400/500/600元 长沙周边 半套/全套/兼职 服务论坛 - Powered by zzxs!", "zzxsp.cn", "CN", "中国香港特别行政区", "Hong Kong", "http://zzxsp.cn", "Hong Kong Communications International Co., Limited", "", "140227", "Hong Kong Communications International Co., Limited", ""]
    #
    #  fields: "host,protocol,title"
    results.each do |result|
      Rails.logger.info "== result: #{result.inspect}"
      host = result[0]
      protocol = result[1]

      # 清理host，移除端口号, 移除 http://   https://    www.
      clean_host = host.gsub(/:\d+$/, '').gsub(/.*\/\//,'').sub(/^www./,'')

      # 创建新的Server记录
      unless Server.exists?(name: clean_host)
        Server.create name: clean_host,
          domain_protocol: protocol,
          level: 2,
          comment: "from FOFA subdomain scan of: #{server.name}-#{server.id}",
          project_id: server.project_id,
          title_of_fofa: result[2]
      end

      Rails.logger.info "已保存子域名: #{clean_host}"
    end
  end

  def query_count(options)
    Rails.logger.info "== in query_count, options:#{options.inspect}"
    server = options[:server]
    query_string = options[:query_string]

    # 根据搜索策略构建查询语句
    Rails.logger.info "== FOFA query: #{query_string}"

    # 编码查询语句
    encoded_query = Base64.strict_encode64(query_string)
    Rails.logger.info "== FOFA encoded_query : #{encoded_query}"

    # API请求参数
    base_params = {
      key: @api_key,
      qbase64: encoded_query,
      size: 1,  # 仅仅查询多少条记录
      fields: "host,protocol,title"
    }

    results = []
    page = 1

    begin
      # 合并当前页码到参数中
      params = base_params.merge(page: page)

      # 构建curl命令
      query_string_parts = params.map { |k, v| "#{k}=#{v}" }.join('&')
      full_url = "#{@url}?#{query_string_parts}"

      # 使用curl命令发送请求
      curl_command = "curl -s \"#{full_url}\""
      Rails.logger.info "== FOFA curl_command: #{curl_command}"

      stdout, stderr, status = Open3.capture3(curl_command)

      # 检查curl命令是否成功执行
      unless status.success?
        Rails.logger.error "== curl命令执行失败: stderr: #{stderr}, stdout: #{stdout}, status: #{status}"
        return
      end

      # 解析JSON响应
      data = JSON.parse(stdout)

      if data["error"]
        Rails.logger.error "FOFA查询错误: #{data}"
      end

      if query_string.include? 'domain*='
        server.update subdomain_count_base_name_of_fofa_result: (data['size'] || 0)
      elsif query_string.include? 'icon_hash=' 
        server.update subdomain_count_favicon_of_fofa_result: (data['size'] || 0)
      else
        server.update subdomain_count_main_domain_of_fofa_result: (data['size'] || 0)
      end
      
      # 更新FOFA计数总和
      server.update_related_fofa_count

    rescue => e
      Rails.logger.error e
      Rails.logger.error e.backtrace.join("\n")

      raise # 触发重试机制
    end

    # 添加延迟避免请求过于频繁
    sleep(1)
  end

  def process_and_save_results(results, server = nil)
    return if results.blank?

    # fields: "host,ip,port,protocol,title,domain,country,country_name,city,link,org,banner,asn,org,isp"
    # result: ["zzxsp.cn", "38.181.13.145", "80", "http", "长沙附近约 大学生快餐 100/200/300/400/500/600元 长沙周边 半套/全套/兼职 服务论坛 - Powered by zzxs!", "zzxsp.cn", "CN", "中国香港特别行政区", "Hong Kong", "http://zzxsp.cn", "Hong Kong Communications International Co., Limited", "", "140227", "Hong Kong Communications International Co., Limited", ""]
    #
    #  fields: "host,protocol,title"
    results.each do |result|
      Rails.logger.info "== result: #{result.inspect}"
      host = result[0]
      protocol = result[1]

      # 清理host，移除端口号, 移除 http://   https://    www.
      clean_host = host.gsub(/:\d+$/, '').gsub(/.*\/\//,'').sub(/^www./,'')

      # 创建新的Server记录
      unless Server.exists?(name: clean_host)
        Server.create name: clean_host,
          domain_protocol: protocol,
          level: 2,
          comment: "from FOFA subdomain scan of: #{server.name}-#{server.id}",
          project_id: server.project_id,
          title_of_fofa: result[2]
      end

      Rails.logger.info "已保存子域名: #{clean_host}"
    end
  end
end
