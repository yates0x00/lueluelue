class ServersController < ApplicationController
  before_action :set_server, only: %i[ show edit update destroy ]

  # GET /servers or /servers.json
  def index
    @servers = Server
    @servers = @servers.where("name like '%#{params[:name]}%'") if params[:name].present?
    @servers = @servers.where('project_id = ? ', params[:project_id]) if params[:project_id].present?
    @servers = @servers.where("wafwoof_result like '%No WAF detected%'") if params[:is_detected_waf].present? && params[:is_detected_waf] == 'no'
    @servers = @servers.where("wafwoof_result not like '%No WAF detected%'") if params[:is_detected_waf].present? && params[:is_detected_waf] == 'yes'
    @servers = @servers.where("wappalyzer_result is not null") if params[:is_detected_by_wappalyzer].present? && params[:is_detected_by_wappalyzer] == 'yes'
    @servers = @servers.where("ehole_result is not null") if params[:is_detected_by_ehole].present? && params[:is_detected_by_ehole] == 'yes'
    @servers = @servers.where("ehole_result like '%#{params[:ehole_text]}%'") if params[:ehole_text].present?
    @servers = @servers.where("the_harvester_result is not null") if params[:is_detected_by_the_harvester].present? && params[:is_detected_by_the_harvester] == 'yes'
    @servers = @servers.where("nmap_result is not null") if params[:is_detected_by_nmap].present? && params[:is_detected_by_nmap] == 'yes'
    @servers = @servers.where("nuclei_https_result is not null or nuclei_http_result is not null") if params[:is_detected_by_nuclei].present? && params[:is_detected_by_nmap] == 'yes'
    @servers = @servers.where("nmap_result is not null") if params[:is_detected_by_nmap].present? && params[:is_detected_by_nmap] == 'yes'
    @servers = @servers.where("level = ?", params[:level]) if params[:level].present?
    @total_count = @servers.count
    @servers = @servers.order(params["order_by"] || "id desc")
      .order('level asc')
      .page(params[:page]).per(params[:per_page] || 1000)
  end

  # GET /servers/1 or /servers/1.json
  def show
  end

  # GET /servers/new
  def new
    @server = Server.new
  end

  def new_batch_servers
  end

  def create_batch_servers
    @server = Server.new
    params[:names].split("\n").each do |temp_name|
      if temp_name.include?('https://')
        name = temp_name.split("https://")[1]
        @server = Server.find_or_create_by! name: name, domain_protocal: 'https'
      elsif temp_name.include?("http://")
        name = temp_name.split("http://")[1]
        @server = Server.find_or_create_by! name: name, domain_protocal: 'http'
      end
    end

    if @server.save
      redirect_to servers_url, notice: 'Operation succeeded'
    else
      render :new, notice: 'Please check the input'
    end
  end

  # GET /servers/1/edit
  def edit
  end

  # POST /servers or /servers.json
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

    headers = %w{ID Name Domain Comment Wafwoof_result dig_result Pure_ip title Os_type web_server Web_framework Web_language Observer_ward_result Ehole_result Level The_harvester_result Wappalyzer_result Nuclei_https_result Nuclei_http_result Nuclei_manual_result Domain_protocal Project_id Is_detected_by_wafwoof_result Is_detected_by_dig_result Is_detected_by_observer_ward_result Is_detected_by_ehole_result Is_detected_by_wappalyzer_result Is_detected_by_nuclei_https_result Is_detected_by_the_harvester_result Is_detected_by_nuclei_http_result Is_detected_by_nuclei_manual_result}
    file = CSV.generate do |csv|
      csv << headers
      Server.all.each_with_index do |server, index|
      row = [
        server.id, server.name, server.domain, server.comment, server.wafwoof_result, server.dig_result, server.pure_ip, server.title, server.os_type,
        server.web_server, server.web_framework, server.web_language, server.observer_ward_result, server.ehole_result, server.level,
        server.the_harvester_result, server.wappalyzer_result, server.nuclei_https_result, server.nuclei_http_result,
        server.nuclei_manual_result, server.domain_protocal, server.project_id, server.is_detected_by_wafwoof_result,
        server.is_detected_by_dig_result, server.is_detected_by_observer_ward_result, server.is_detected_by_ehole_result,
        server.is_detected_by_wappalyzer_result, server.is_detected_by_nuclei_https_result, server.is_detected_by_the_harvester_result,
        server.is_detected_by_nuclei_http_result, server.is_detected_by_nuclei_manual_result
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
      params.require(:server).permit(:name, :domain, :comment, :wafwoof_result, :dig_result, :pure_ip, :title, :os_type, :web_server, :web_framework, :web_language, :observer_ward_result, :ehole_result, :level, :the_harvester_result, :wappalyzer_result, :nuclei_https_result, :nuclei_http_result, :nuclei_manual_result, :domain_protocal, :project_id,
                                    :is_detected_by_wafwoof_result, :is_detected_by_dig_result, :is_detected_by_observer_ward_result, :is_detected_by_ehole_result, :is_detected_by_wappalyzer_result, :is_detected_by_nuclei_https_result, :is_detected_by_the_harvester_result, :is_detected_by_nuclei_http_result, :is_detected_by_nuclei_manual_result)
    end
end
