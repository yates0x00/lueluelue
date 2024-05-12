class IpsController < ApplicationController
  before_action :set_ip, only: %i[ show edit update destroy ]
  def index
    @ips = Ip.all
    @ips = @ips.joins(:servers).where("servers.name like '%#{params[:like_name]}%'") if params[:like_name].present?
    @ips = @ips.joins(:servers).where("servers.name = ?", params[:equal_name]) if params[:equal_name].present?
    @ips = @ips.joins(:servers).where("servers.level in (?)", params[:levels]) if params[:levels].present?

    @ips = @ips.joins(:servers => :project).where("projects.id = ?", params[:project_id]) if params[:project_id].present?
    @total_count = @ips.count
    params[:page] ||= 1
    params[:per_page] ||= 500
    @ips = @ips.order("id desc").page(params[:page]).per(params[:per_page])
  end

  def new_batch_ips
  end

  def create_batch_ips
    @ip = Ip.new(ip_params)
    params[:ips].split("\n").each do |ip|
      @ip = Ip.find_or_create_by! ip: ip
    end

    if @ip.save
      redirect_to ips_url, notice: 'Operation succeeded'
    else
      render :new
    end
  end

  def show
  end

  def download_csv
    require 'csv'

    headers = %w{ID Ip NmapResult Location}
    file = CSV.generate do |csv|
      csv << headers
      Ip.all.each_with_index do |ip, index|
        row = [ip.id, ip.ip, ip.nmap_result, ip.location]
        csv << row
      end
    end
    send_data file.encode("utf-8", "utf-8"), :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment;filename=ips.csv"
  end

  # GET /ips/1/edit
  def edit
  end

  # POST /ips or /ips.json
  def create
    @ip = Ip.new(ip_params)

    respond_to do |format|
      if @ip.save
        format.html { redirect_to ip_url(@ip), notice: "Ip was successfully created." }
        format.json { render :show, status: :created, location: @ip }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ips/1 or /ips/1.json
  def update
    respond_to do |format|
      if @ip.update(ip_params)
        format.html { redirect_to ip_url(@ip), notice: "Ip was successfully updated." }
        format.json { render :show, status: :ok, location: @ip }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ips/1 or /ips/1.json
  def destroy
    @ip.destroy

    respond_to do |format|
      format.html { redirect_to ips_url, notice: "Ip was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ip
      @ip = Ip.find(params[:id])
    end

    def ip_params
      params.require(:ip).permit(:ip, :location, :nmap_result)
    end
end
