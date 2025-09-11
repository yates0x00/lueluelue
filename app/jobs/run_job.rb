class RunJob < ApplicationJob
  queue_as :default

  # options:
  # command:
  # entity
  # is_detected_by_column
  # result_column
  def perform options
    command = options[:command]

    result = `#{command}`
    Rails.logger.info "== command: #{command}"
    Rails.logger.info "== result: #{result}"

    result_column = options[:result_column]

    entity = options[:entity]
    if entity.present?
      entity.update options[:is_detected_by_column] => true if options[:is_detected_by_column].present?
      entity.update result_column  => result if result_column.present?
    end

    # 针对wafwoof :
    if result_column == 'wafwoof_result'
      if entity.wafwoof_result.include? "No WAF detected"
        entity.is_confirmed_not_behind_waf = true
      elsif entity.wafwoof_result.include? "is behind"
        entity.is_confirmed_behind_waf = true
      end
      entity.save!
    end

  end
end
