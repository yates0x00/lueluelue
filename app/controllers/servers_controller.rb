class ServersController < ApplicationController
  before_action :set_server, only: %i[ show edit update destroy ]

  # GET /servers or /servers.json
  def index
    @servers = Server
    @servers = @servers.where("name like '%#{params[:name]}%'") if params[:name].present?
    @servers = @servers.where("wafwoof_result like '%No WAF detected%'") if params[:is_detected_waf].present? && params[:is_detected_waf] == 'no'
    @servers = @servers.where("wafwoof_result not like '%No WAF detected%'") if params[:is_detected_waf].present? && params[:is_detected_waf] == 'yes'
    @servers = @servers.where("wappalyzer_result is not null") if params[:is_detected_by_wappalyzer].present? && params[:is_detected_by_wappalyzer] == 'yes'
    @servers = @servers.where("ehole_result is not null") if params[:is_detected_by_ehole].present? && params[:is_detected_by_ehole] == 'yes'
    @servers = @servers.where("ehole_result like '%#{params[:ehole_text]}%'") if params[:ehole_text].present?
    @servers = @servers.where("the_harvester_result is not null") if params[:is_detected_by_the_harvester].present? && params[:is_detected_by_the_harvester] == 'yes'
    @servers = @servers.where("nmap_result is not null") if params[:is_detected_by_nmap].present? && params[:is_detected_by_nmap] == 'yes'
    @servers = @servers.where("nuclei_https_result is not null or nuclei_http_result is not null") if params[:is_detected_by_nuclei].present? && params[:is_detected_by_nmap] == 'yes'
    @servers = @servers.where("nmap_result is not null") if params[:is_detected_by_nmap].present? && params[:is_detected_by_nmap] == 'yes'
    @servers = @servers.where("level = ?") if params[:level].present?
    @total_count = @servers.count

    @servers = @servers.order(params["order_by"] || "id desc")
      .order('level asc')
      .page(params[:page]).per(500)
  end

  # GET /servers/1 or /servers/1.json
  def show
  end

  # GET /servers/new
  def new
    @server = Server.new
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_server
      @server = Server.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def server_params
      params.require(:server).permit(:name, :domain, :comment, :wafwoof_result, :dig_result)
    end
end
