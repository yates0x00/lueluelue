class JobsController < ApplicationController

  COMMAND_NAMES = %w{dig wafwoof wappalyzer  ehole dirsearch nuclei nmap_for_special_ports nmap_top_1000
    shuize theharvester }

  def index
    @delayed_jobs = DelayedJob.all.page(params[:page]).per(params[:per]).order('id desc')
  end

  def create

    servers = Server.where('project_id = ?', params[:project_id])
    job_name = params[:job_name]
    if job_name.present?
      if job_name == 'ALL'
        #run all jobs
      else
        send "command_#{job_name}"
      end
    else
      return
    end
  end

  def destroy
  end

  def create_by_batch
  end
  private


  COMMAND_NAMES.each {|name|
    define_method "command_#{name}" do |options|
      config_item = ConfigItem.find_by_name(name: name)
      return if config_item.blank?

      command = config_item.value
      server = options[:server]
      command = command.gsub('SERVER_NAME', server.name).gsub('PROTOCAL', server.domain_protocol || 'https')
        .gsub('RESULT_FILE', "result_#{name}_server_#{server.name}")
      result = `#{command}`

      begin
        server.update "#{name}_result" => result
      rescue Exception => e
        Rails.logger.error e
        Rails.logger.error e.backtrace.join("\n")
      end
    end
  }

end
