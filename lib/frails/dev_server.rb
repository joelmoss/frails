class Frails::DevServer
  # Configure dev server connection timeout (in seconds), default: 0.01
  # Frails.dev_server.connect_timeout = 1
  cattr_accessor(:connect_timeout) { 0.01 }

  # rubocop:disable Style/RescueStandardError
  def running?
    Socket.tcp(host, port, connect_timeout: connect_timeout).close
    true
  rescue
    false
  end
  # rubocop:enable Style/RescueStandardError

  def host_with_port
    "#{host}:#{port}"
  end

  def host
    'localhost'
  end

  def port
    3035
  end
end
