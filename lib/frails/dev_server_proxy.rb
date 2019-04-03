require 'rack/proxy'

class Frails::DevServerProxy < Rack::Proxy
  delegate :dev_server, to: :@frails

  def initialize(app = nil, opts = {})
    @frails = Frails.instance
    super
  end

  def rewrite_response(response)
    _status, headers, _body = response
    headers.delete 'transfer-encoding'
    response
  end

  def perform_request(env)
    if env['PATH_INFO'].start_with?('/packs') && dev_server.running?
      host = dev_server.host_with_port
      env['HTTP_HOST'] = env['HTTP_X_FORWARDED_HOST'] = env['HTTP_X_FORWARDED_SERVER'] = host
      env['HTTP_X_FORWARDED_PROTO'] = env['HTTP_X_FORWARDED_SCHEME'] = 'http'
      env['SCRIPT_NAME'] = ''

      super(env)
    else
      @app.(env)
    end
  end
end
