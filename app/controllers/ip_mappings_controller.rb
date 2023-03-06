class IpMappingsController < ApplicationController

  def index
    @ip_mappings = IpMapping.all
    @ip_mappings = @ip_mappings.joins(:server).where("name like '%#{params[:server_name]}%'") if params[:server_name].present?
    @total_count = @ip_mappings.count
    @ip_mappings = @ip_mappings.order("id desc").page(params[:page]).per(500)
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

end
