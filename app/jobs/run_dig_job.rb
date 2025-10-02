class RunDigJob < ApplicationJob
  queue_as :default
  # 遇到死锁时自动重试（最多3次）
  #retry_on ActiveRecord::Deadlocked, attempts: 3, wait: 2.seconds

  def perform(server)
    # 安全执行dig命令（处理可能的特殊字符）
    clean_name = server.name.chomp  # 移除可能的^M等字符
    command = [ENV['COMMAND_OF_DIG'], "+short", clean_name]
    stdout, stderr, status = Open3.capture3(*command)
    dig_result = "stdout: #{stdout}\nstderr: #{stderr}\nexit status: #{status.exitstatus}"

    Rails.logger.info "== Dig command for #{server.name}: #{command.join(' ')}"
    Rails.logger.info "== Dig result: #{dig_result}"

    # 更新服务器记录
    server.update(
      is_detected_by_dig: true,
      dig_result: dig_result
    )
  rescue => e
    Rails.logger.error "== DigJob failed for #{server.name}: #{e.message}"
    raise  # 触发重试机制
  end
end

