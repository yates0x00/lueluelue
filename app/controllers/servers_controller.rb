class ServersController < ApplicationController
  before_action :set_server, only: %i[ show edit update destroy ]
  def readme
  end

  def index
    @servers = Server
    @servers = @servers.where("name like '%#{params[:like_name]}%'") if params[:like_name].present?
    @servers = @servers.where("name = ?", params[:equal_name]) if params[:equal_name].present?
    @servers = @servers.where('project_id = ? ', params[:project_id]) if params[:project_id].present?
    @servers = @servers.where("is_confirmed_not_behind_waf = 1") if params[:is_detected_waf].present? && params[:is_detected_waf] == 'no'
    @servers = @servers.where("is_confirmed_behind_waf = 1") if params[:is_detected_waf].present? && params[:is_detected_waf] == 'yes'
    @servers = @servers.where("wappalyzer_result is not null") if params[:is_detected_by_wappalyzer].present? && params[:is_detected_by_wappalyzer] == 'yes'
    @servers = @servers.where("ehole_result is not null") if params[:is_detected_by_ehole].present? && params[:is_detected_by_ehole] == 'yes'
    @servers = @servers.where("ehole_result like '%#{params[:ehole_text]}%'") if params[:ehole_text].present?
    @servers = @servers.where("the_harvester_result is not null") if params[:is_detected_by_the_harvester].present? && params[:is_detected_by_the_harvester] == 'yes'
    #@servers = @servers.where("nmap_result is not null") if params[:is_detected_by_nmap].present? && params[:is_detected_by_nmap] == 'yes'
    @servers = @servers.where("nmap_result_for_special_ports is not null") if params[:is_detected_by_nmap_for_special_ports].present? && params[:is_detected_by_nmap_for_special_ports] == 'yes'
    @servers = @servers.where("nuclei_https_result is not null or nuclei_http_result is not null") if params[:is_detected_by_nuclei].present? && params[:is_detected_by_nmap] == 'yes'
    @servers = @servers.where("level = ?", params[:level]) if params[:level].present?
    @servers = @servers.where(level: params[:level_by_range].split(',')) if params[:level_by_range].present?
    @servers = @servers.where("is_stared = ?", params[:is_stared]) if params[:is_stared].present?
    @servers = @servers.where("dig_result is not null and dig_result != ''") if params[:is_detected_by_dig].present? && params[:is_detected_by_dig] == 'yes'
    @total_count = @servers.count
    @servers = @servers.order(params["order_by"] || "id desc")
      .order('level asc')
      .page(params[:page]).per(params[:per_page] || 1000)
  end

  def fofa_count
    # 获取最新的project_id作为默认值
    latest_project = Project.order(id: :desc).first
    project_id = params[:project_id].presence || latest_project&.id
    
    # 构建查询条件
    servers_scope = Server.where(project_id: project_id)
    
    # 添加favicon_hash_of_fofa过滤条件
    case params[:favicon_hash_of_fofa_filter]
    when 'null'
      servers_scope = servers_scope.where(favicon_hash_of_fofa: nil)
    when 'not_null'
      servers_scope = servers_scope.where.not(favicon_hash_of_fofa: nil)
    end
    
    # 添加is_need_to_fetch_from_fofa过滤条件
    case params[:is_need_to_fetch_from_fofa_filter]
    when 'true'
      servers_scope = servers_scope.where(is_need_to_fetch_from_fofa: true)
    when 'false'
      servers_scope = servers_scope.where(is_need_to_fetch_from_fofa: false)
    end
    
    # 处理排序参数
    sort_column = params[:sort_by]
    sort_direction = params[:sort_order] || 'desc'
    
    # 验证排序字段是否有效
    valid_sort_columns = %w[
      subdomain_total_count_of_fofa_result
      subdomain_count_main_domain_of_fofa_result
      subdomain_count_base_name_of_fofa_result
      subdomain_count_favicon_of_fofa_result
    ]
    
    # 应用排序
    if sort_column.present? && valid_sort_columns.include?(sort_column)
      servers_scope = servers_scope.order("#{sort_column} #{sort_direction}")
    else
      # 默认按ID倒序排列
      servers_scope = servers_scope.order(id: :desc)
    end
    
    # 查询符合条件的servers
    @servers = servers_scope.page(params[:page]).per(params[:per_page] || 1000)
    
    # 计算总数
    @total_count = Server.where(project_id: project_id).count
    
    # 计算各字段存在值的条目数量
    @subdomain_main_count = servers_scope.where.not(subdomain_count_main_domain_of_fofa_result: nil).count
    @subdomain_base_count = servers_scope.where.not(subdomain_count_base_name_of_fofa_result: nil).count
    @subdomain_favicon_count = servers_scope.where.not(subdomain_count_favicon_of_fofa_result: nil).count
    @subdomain_total_count = servers_scope.where.not(subdomain_total_count_of_fofa_result: nil).count
    @favicon_hash_count = servers_scope.where.not(favicon_hash_of_fofa_result: nil).count
    
    # 计算favicon_hash_of_fofa_result字段中不包含ERR的数量
    @favicon_hash_non_empty_count = servers_scope.where.not(favicon_hash_of_fofa_result: nil).count
    @favicon_hash_without_err_count = servers_scope.where.not(favicon_hash_of_fofa_result: nil).where("favicon_hash_of_fofa_result NOT LIKE '%ERR%'").count
  end

  def toggle_is_need_to_fetch_from_fofa
    @server = Server.find(params[:id])
    @server.update(is_need_to_fetch_from_fofa: !@server.is_need_to_fetch_from_fofa)
    respond_to do |format|
      format.json { render json: { success: true, is_need_to_fetch_from_fofa: @server.is_need_to_fetch_from_fofa } }
    end
  end

  def update_fofa_count
    @server = Server.find(params[:id])
    
    # 根据type参数确定查询类型
    if params[:type] == 'favicon'
      # 更新 favicon_hash_of_fofa
      query_string = "icon_hash=\"#{@server.favicon_hash_of_fofa}\""
      
      # 调用FOFA工具查询数量
      fofa_tool = FofaTool.new
      fofa_tool.query_count(server: @server, query_string: query_string)
      
      # 更新FOFA计数总和
      @server.update_related_fofa_count
      
      respond_to do |format|
        format.json { render json: { success: true, message: 'FOFA计数已更新', subdomain_count: @server.reload.subdomain_count_favicon_of_fofa_result } }
      end
    else
      respond_to do |format|
        format.json { render json: { success: false, message: '不支持的查询类型' }, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def new
    @server = Server.new
  end

  def new_batch_servers
  end

  def create_batch_servers
    @server = Server.new
    params[:names].split("\n").each do |temp_name|
      temp_name = temp_name.gsub("\r", "").rstrip
      next if temp_name.blank?

      if temp_name.include?('https://')
        name = temp_name.split("https://")[1]
        @server = Server.find_or_create_by! name: name, domain_protocol: 'https'
      elsif temp_name.include?("http://")
        name = temp_name.split("http://")[1]
        @server = Server.find_or_create_by! name: name, domain_protocol: 'http'
      else
        name = temp_name
        @server = Server.find_or_create_by! name: name, domain_protocol: 'https'
      end

      @server.update comment: params[:comment], project_id: params[:project_id], level: params[:level]
    end

    if @server.save
      redirect_to servers_url, notice: 'Operation succeeded'
    else
      render :new, notice: 'Please check the input'
    end
  end

  def edit
  end

  def create
    @server = Server.new(server_params)

    respond_to do |format|
      if @server.save
        format.html { redirect_to server_url(@server), notice: "Server was successfully created." }
        format.json { render :show, status: :created, location: @server }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /servers/1 or /servers/1.json
  def update
    respond_to do |format|
      Rails.logger.info "==  format: #{format }"

      if @server.update(server_params)
        format.html { redirect_to server_url(@server), notice: "Server was successfully updated." }
        if server_params[:favicon_url].present?
          new_favicon_hash = `iconhash #{server_params[:favicon_url]}`.strip
          @server.update(favicon_hash_of_fofa: new_favicon_hash)
          @server.update_related_fofa_count
        end

        format.json { render json: { status: 'success', message: 'Server was successfully updated.', server: @server }, status: :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { status: 'error', message: @server.errors.full_messages.join(', ') }, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /servers/1 or /servers/1.json
  def destroy
    @server.destroy

    respond_to do |format|
      format.html { redirect_to servers_url, notice: "Server was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def download_csv
    require 'csv'

    headers = %w{ID Name Comment 确认没有WAF dig_result Pure_ip title
      web_server Web_framework Web_language Observer_ward_result
      Ehole_result Level The_harvester_result Wappalyzer_result Nuclei_https_result
      Nuclei_http_result Nuclei_manual_result Domain_protocal Project_id
      wafwoof_result dig_result observer_ward_result ehole_result wappalyzer_result nuclei_https_result the_harvester_result}
    file = CSV.generate do |csv|
      csv << headers
      filtered_servers.each do |server|
      row = [
        server.id, server.name, server.comment, server.is_confirmed_not_behind_waf, server.dig_result, server.pure_ip, server.title,
        server.web_server, server.web_framework, server.web_language, server.observer_ward_result,
        server.ehole_result, server.level,
        server.the_harvester_result, server.wappalyzer_result, server.nuclei_https_result, server.nuclei_http_result,
        server.nuclei_manual_result, server.domain_protocol, server.project_id,
        server.dig_result, server.observer_ward_result, server.ehole_result,
        server.wappalyzer_result, server.nuclei_https_result, server.the_harvester_result,
      ]
        csv << row
      end
    end
    send_data file.encode("utf-8", "utf-8"), :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment;filename=servers.csv"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_server
      @server = Server.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def server_params
      params.require(:server).permit(:name, :domain, :comment, :wafwoof_result, :dig_result, :pure_ip, :title, :os_type, :web_server, :web_framework, :web_language,
                                     :observer_ward_result, :ehole_result, :level, :the_harvester_result, :wappalyzer_result, :nuclei_https_result, :nuclei_http_result,
                                     :nuclei_manual_result, :domain_protocol, :project_id, :is_detected_by_wafwoof, :is_detected_by_dig, :is_detected_by_observer_ward,
                                     :is_detected_by_ehole, :is_detected_by_wappalyzer, :is_detected_by_nuclei_https, :is_detected_by_the_harvester, :is_detected_by_nuclei_http,
                                     :is_detected_by_nuclei_manual, :is_stared, :favicon_url)
    end

    # Filter servers based on params
    def filtered_servers
      servers = Server.all
      servers = servers.where("name like '%#{params[:like_name]}%'") if params[:like_name].present?
      servers = servers.where("name = ?", params[:equal_name]) if params[:equal_name].present?
      servers = servers.where('project_id = ? ', params[:project_id]) if params[:project_id].present?
      servers = servers.where("is_confirmed_not_behind_waf = 1") if params[:is_detected_waf].present? && params[:is_detected_waf] == 'no'
      servers = servers.where("is_confirmed_behind_waf = 1") if params[:is_detected_waf].present? && params[:is_detected_waf] == 'yes'
      servers = servers.where("wappalyzer_result is not null") if params[:is_detected_by_wappalyzer].present? && params[:is_detected_by_wappalyzer] == 'yes'
      servers = servers.where("ehole_result is not null") if params[:is_detected_by_ehole].present? && params[:is_detected_by_ehole] == 'yes'
      servers = servers.where("ehole_result like '%#{params[:ehole_text]}%'") if params[:ehole_text].present?
      servers = servers.where("the_harvester_result is not null") if params[:is_detected_by_the_harvester].present? && params[:is_detected_by_the_harvester] == 'yes'
      #@servers = @servers.where("nmap_result is not null") if params[:is_detected_by_nmap].present? && params[:is_detected_by_nmap] == 'yes'
      servers = servers.where("nmap_result_for_special_ports is not null") if params[:is_detected_by_nmap_for_special_ports].present? && params[:is_detected_by_nmap_for_special_ports] == 'yes'
      servers = servers.where("nuclei_https_result is not null or nuclei_http_result is not null") if params[:is_detected_by_nuclei].present? && params[:is_detected_by_nmap] == 'yes'
      servers = servers.where("level = ?", params[:level]) if params[:level].present?
      servers = servers.where(level: params[:level_by_range].split(',')) if params[:level_by_range].present?
      servers = servers.where("is_stared = ?", params[:is_stared]) if params[:is_stared].present?
      servers = servers.where("dig_result is not null and dig_result != ''") if params[:is_detected_by_dig].present? && params[:is_detected_by_dig] == 'yes'
      servers
    end
end
