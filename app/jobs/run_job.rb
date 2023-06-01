class RunJob < ApplicationJob

  queue_as :default

  def perform options
    command = options[:command]

    result = `#{command}`
    Rails.logger.info "== command: #{command}"
    Rails.logger.info "== result: #{result}"

    entity = options[:entity]
    if entity.present?
      entity.send "#{options[:attribute]}=", result
      Rails.logger.info "== entity: #{entity.inspect}"
      entity.save!
    end
  end
end
