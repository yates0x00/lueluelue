class IpMappingsController < ApplicationController
  before_action :set_ip_mapping, only: %i[ show edit update destroy ]

  def index
    @ip_mappings = IpMapping.all
    @ip_mappings = @ip_mappings.joins(:server).where("name like '%#{params[:like_name]}%'") if params[:like_name].present?
    @ip_mappings = @ip_mappings.joins(:server).where("name = ?", params[:equal_name]) if params[:equal_name].present?
    @total_count = @ip_mappings.count
    @ip_mappings = @ip_mappings.order("id desc").page(params[:page]).per(500)
  end

  # GET /ip_mappings/1 or /ip_mappings/1.json
  def show
  end

  # GET /ip_mappings/new
  def new
    @ip_mapping = IpMapping.new
  end

  # GET /ip_mappings/1/edit
  def edit
  end

  # POST /ip_mappings or /ip_mappings.json
  def create
    @ip_mapping = IpMapping.new(ip_mapping_params)

    respond_to do |format|
      if @ip_mapping.save
        format.html { redirect_to ip_mapping_url(@ip_mapping), notice: "IpMapping was successfully created." }
        format.json { render :show, status: :created, location: @ip_mapping }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ip_mapping.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ip_mappings/1 or /ip_mappings/1.json
  def update
    respond_to do |format|
      if @ip_mapping.update(ip_mapping_params)
        format.html { redirect_to ip_mapping_url(@ip_mapping), notice: "IpMapping was successfully updated." }
        format.json { render :show, status: :ok, location: @ip_mapping }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ip_mapping.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ip_mappings/1 or /ip_mappings/1.json
  def destroy
    @ip_mapping.destroy

    respond_to do |format|
      format.html { redirect_to ip_mappings_url, notice: "IpMapping was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def download_csv
    require 'csv'
    headers = %w{ID Ip Server}
    file = CSV.generate do |csv|
      csv << headers
      IpMapping.all.each_with_index do |ip_mapping, index|
        row = [ip_mapping.id, ip_mapping.ip.try(:ip), ip_mapping.server.try(:name)]
        csv << row
      end
    end
    send_data file.encode("utf-8", "utf-8"), :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment;filename=ip_mappings.csv"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ip_mapping
      @ip_mapping = IpMapping.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ip_mapping_params
      params.require(:ip_mapping).permit(:ip_id, :server_id)
    end
end
