class IpsController < ApplicationController
  #before_action :set_server, only: %i[ show edit update destroy ]

  def index
    @ips = Ip.all
    @ips = @ips.joins(:servers).where("servers.name like '%#{params[:server_name]}%'") if params[:server_name].present?
    #@ips = @ips.where("wafwoof_result like '%No WAF detected%'") if params[:is_detected_waf].present? && params[:is_detected_waf] == 'no'
    @total_count = @ips.count
    @ips = @ips.order("id desc").page(params[:page]).per(500)
  end

  def new_batch_ips
  end

  def create_batch_ips
    @ip = Ip.new
    params[:ips].split("\n").each do |ip|
      @ip = Ip.find_or_create_by! ip: ip
    end

    if @ip.save
      redirect_to ips_url, notice: 'Operation succeeded'
    else
      render :new
    end
  end

  # GET /servers/1 or /servers/1.json
  def show
    @server = Server.where("id=?")
  end
  def show2
    #@server = Server.where("name like '#{params[:name]}' ")
    sql = "select * from servers where name like '#{params[:name]}'"
    @server = ActiveRecord::Base.connection.exec_query(sql)
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

end
