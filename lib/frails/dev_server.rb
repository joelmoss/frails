# frozen_string_literal: true

class Frails::DevServer
  # rubocop:disable Style/RescueStandardError
  def running?
    Socket.tcp(host, port, connect_timeout: 0.01).close
    true
  rescue
    false
  end
  # rubocop:enable Style/RescueStandardError

  def host_with_port
    "#{host}:#{port}"
  end

  def host
    ENV['FRAILS_DEV_SERVER_HOST'] || 'localhost'
  end

  def port
    ENV['FRAILS_DEV_SERVER_PORT'] || 8080
  end
end
