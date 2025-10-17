class RunGobusterJob < ApplicationJob
  queue_as :default

  def perform(server)
    result = ''
    result += `#{ENV['COMMAND_OF_GOBUSTER']} dir -u #{server.domain_protocol}://#{server.name} -w /opt/app/SecLists/dir_file.txt -t 50 -b 403,404 --random-agent`
    result += `#{ENV['COMMAND_OF_GOBUSTER']} dir -u #{server.domain_protocol}://#{server.name} -w /opt/app/SecLists/Discovery/Web-Content/raft-small-files-lowercase.txt -t 50 -b 403,404 --random-agent`
    result += `#{ENV['COMMAND_OF_GOBUSTER']} dir -u #{server.domain_protocol}://#{server.name} -w /opt/app/SecLists/Discovery/Web-Content/raft-small-directories-lowercase.txt -t 50 -b 403,404 --random-agent`

    server.update(
      is_detected_by_gobuster: true,
      gobuster_result: result
    )
  rescue => e
    Rails.logger.error "== RunGobusterJob failed for #{server.name}: #{e.message}"
    raise  # 触发重试机制
  end
end

