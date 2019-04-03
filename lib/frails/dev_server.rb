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
    Rails.configuration.frails.dev_server_host
  end

  def port
    Rails.configuration.frails.dev_server_port
  end
end
