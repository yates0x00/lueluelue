# config/log4r.rb
require 'log4r'
require 'log4r/outputter/datefileoutputter'
require 'fileutils'

# 补全 Log4r 内部校验所需的 ALL/OFF 常量
unless Log4r.const_defined?(:Log4rTools)
  Log4r::Log4rTools = Module.new
end
unless Log4r::Log4rTools.const_defined?(:ALL)
  Log4r::Log4rTools.const_set(:ALL, 0)
end
unless Log4r::Log4rTools.const_defined?(:OFF)
  Log4r::Log4rTools.const_set(:OFF, 5)
end

# 动态获取启动程序名称
def determine_program_name
  program_path = $0
  program_name = File.basename(program_path, '.*')

  # 特殊处理 Rails 命令（如 rails server → rails_server）
  if program_name == 'rails' && ARGV.any?
    subcommand = ARGV.first.downcase
    program_name = "rails_#{subcommand}" if %w[server s console c runner].include?(subcommand)
  end

  program_name
end

# 关键修复：为 Log4r::Logger 同时新增 formatter（读）和 formatter=（写）方法
# 确保兼容 Rails 7 BroadcastLogger 的格式操作要求
Log4r::Logger.class_eval do
  # 读取格式：返回第一个输出器的格式（与之前一致）
  def formatter
    outputters.first&.formatter
  end

  # 写入格式：将格式设置到所有输出器（Rails 会调用此方法）
  def formatter=(new_formatter)
    outputters.each do |outputter|
      outputter.formatter = new_formatter if outputter.respond_to?(:formatter=)
    end
  end
end

# 确定日志目录（确保 Rails.root 已初始化）
program_name = determine_program_name
log_dir = Rails.root.join('log')
log_file = File.join(log_dir, program_name)
puts "=== log_dir: #{log_dir}, log_file: #{log_file}"

FileUtils.mkdir_p(log_dir) # 确保日志目录存在

# 定义日志格式（Log4r 原生格式）
log_formatter = Log4r::PatternFormatter.new(
  pattern: "%d [%l] [PID:%p] %m",
  date_pattern: "%Y-%m-%d %H:%M:%S"
)

# 定义按程序名+日期分割的日志输出器
log_outputter = Log4r::DateFileOutputter.new(
  "#{program_name}_log_outputter",
  filebase: File.join(Rails.root, 'log', program_name),  # 替代 log_dir.join(program_name).to_s
  date_pattern: "%Y-%m-%d",                 # 日期后缀（如 2025-09-12）
  formatter: log_formatter,                 # 绑定 Log4r 原生格式
  trunc: false,
  create: true,
  level: case Rails.env                     # 整数级别（0=DEBUG，1=INFO）
         when 'development' then 0
         when 'test'        then 1
         when 'production'  then 1
         else 1
         end
)


# 配置主日志器（使用正确的 add 方法添加输出器）
main_logger = Log4r::Logger.new("#{program_name}_#{Rails.env}")
main_logger.add(log_outputter)
main_logger.level = log_outputter.level

# 替换 Rails 默认日志器
Rails.application.config.logger = main_logger

# 为 Rails 组件配置日志器（使用组件的基础类）
component_mapping = {
  'ActiveRecord' => 'ActiveRecord::Base',
  'ActionPack'   => 'ActionController::Base',
  'ActionView'   => 'ActionView::Base',
  'ActionMailer' => 'ActionMailer::Base',
  'ActiveJob'    => 'ActiveJob::Base'
}

component_mapping.each do |component_name, base_class_name|
  if Object.const_defined?(base_class_name)
    base_class = Object.const_get(base_class_name)
    component_logger = Log4r::Logger.new("#{component_name}_#{program_name}_#{Rails.env}")
    component_logger.add(log_outputter)
    component_logger.level = main_logger.level
    base_class.logger = component_logger
  end
end

# 输出初始化信息（验证配置生效）
main_logger.info("=" * 50)
main_logger.info("Log4r initialized successfully!")
main_logger.info("Program: #{program_name} | Log File: #{log_outputter.filename}")
main_logger.info("Rails Env: #{Rails.env} | Log Level: #{main_logger.level == 0 ? 'DEBUG' : 'INFO'}")
main_logger.info("=" * 50)

