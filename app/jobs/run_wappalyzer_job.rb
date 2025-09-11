class RunWappalyzerJob < ApplicationJob
  queue_as :default
  #queue_with_priority 10

  # options:
  # command:
  # entity
  # is_detected_by_column
  # result_column
  WAPPALYZER = "node /workspace/coding_tools/wappalyzer/src/drivers/npm/cli.js"
  def perform options
    url = options[:url]
    server = options[:server]
    command = "#{WAPPALYZER} https://#{url}"
    result = `#{command}`
    puts "== result.urls: #{JSON.parse(result)['urls'].inspect}"
    key = JSON.parse(result)['urls'].keys[0]
    puts "== key is: #{key}"
    if JSON.parse(result)['urls'][key]['status'] < 400
      server.update wappalyzer_result: result
    else
      command = "#{WAPPALYZER} http://#{url}"
      result = `#{command}`
      server.update wappalyzer_result: "https is not available, <br/>" + result
    end
    server.update is_detected_by_wappalyzer: true

  end
end
