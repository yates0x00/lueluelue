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
    
    # 查询符合条件的servers，按ID倒序排列
    @servers = Server.where(project_id: project_id)
                     .order(id: :desc)
                     .page(params[:page]).per(params[:per_page] || 1000)
    
    # 计算总数
    @total_count = Server.where(project_id: project_id).count
    
    # 计算各字段存在值的条目数量
    servers_scope = Server.where(project_id: project_id)
    @subdomain_main_count = servers_scope.where.not(subdomain_count_main_domain_of_fofa_result: nil).count
    @subdomain_base_count = servers_scope.where.not(subdomain_count_base_name_of_fofa_result: nil).count
    @subdomain_favicon_count = servers_scope.where.not(subdomain_count_favicon_of_fofa_result: nil).count
    @subdomain_total_count = servers_scope.where.not(subdomain_total_count_of_fofa_result: nil).count
    @favicon_hash_count = servers_scope.where.not(favicon_hash_of_fofa_result: nil).count
  end

  def toggle_is_need_to_fetch_from_fofa
    @server = Server.find(params[:id])
    @server.update(is_need_to_fetch_from_fofa: !@server.is_need_to_fetch_from_fofa)
    respond_to do |format|
      format.json { render json: { success: true, is_need_to_fetch_from_fofa: @server.is_need_to_fetch_from_fofa } }
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
      if @server.update(server_params)
        format.html { redirect_to server_url(@server), notice: "Server was successfully updated." }
        format.json { render :show, status: :ok, location: @server }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @server.errors, status: :unprocessable_entity }
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
                                     :is_detected_by_nuclei_manual, :is_stared)
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
