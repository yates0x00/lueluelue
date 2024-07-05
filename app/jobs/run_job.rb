class RunJob < ApplicationJob

  queue_as :default

  def perform options
    command = options[:command]

    result = `#{command}`
    Rails.logger.info "== command: #{command}"
    Rails.logger.info "== result: #{result}"

    entity = options[:entity]
    if entity.present?
      entity.update options[:is_detected_by_column] => true if options[:is_detected_by_column].present?
      entity.update options[:result_column] => result if options[:result_column].present?
    end

    # 针对wafwoof :
    if entity.result_column == 'wafwoof_result'
      if server.wafwoof_result.include? "No WAF detected"
        server.is_confirmed_not_behind_waf = true
      elsif server.wafwoof_result.include? "is behind"
        server.is_confirmed_behind_waf = true
      end
    end

  end
end
