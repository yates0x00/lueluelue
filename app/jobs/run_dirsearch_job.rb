class RunDirsearchJob< ApplicationJob
  queue_as :default

  def perform options
    command = options[:command]
    server = options[:entity]
    result_file = options[:result_file]
    command_result = `#{command}`
    Rails.logger.info "== command_result: #{command_result}, please check its result file"

    #server.update dirsearch_result: File.read(result_file),
    #  is_detected_by_dirsearch: true
  end
end
