class IpsController < ApplicationController
  #before_action :set_server, only: %i[ show edit update destroy ]

  def index
    @ips = Ip.all
    @ips = @ips.joins(:servers).where("servers.name like '%#{params[:name]}%'") if params[:name].present?
    #@ips = @ips.where("wafwoof_result like '%No WAF detected%'") if params[:is_detected_waf].present? && params[:is_detected_waf] == 'no'

    @total_count = @ips.count
    @ips = @ips.order(params["order_by"] || "id desc")
      .page(params[:page]).per(500)
  end

  def new_some_ips
  end

  def create_some_ips
    @ip = Ip.new
    params[:ips].split("\n").each do |ip|
      @ip = Ip.find_or_create_by! ip: ip
    end

    if @ip.save
      redirect_to ips_url, notice: '操作成功'
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


end
