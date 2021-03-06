# frozen_string_literal: true

require 'rack/proxy'

class Frails::DevServerProxy < Rack::Proxy
  def rewrite_response(response)
    _status, headers, _body = response
    headers.delete 'transfer-encoding'
    response
  end

  def perform_request(env)
    if env['PATH_INFO'].start_with?(public_output_path) && Frails.dev_server.running?
      host = Frails.dev_server.host_with_port
      env['HTTP_HOST'] = env['HTTP_X_FORWARDED_HOST'] = env['HTTP_X_FORWARDED_SERVER'] = host
      env['HTTP_X_FORWARDED_PROTO'] = env['HTTP_X_FORWARDED_SCHEME'] = 'http'
      env['SCRIPT_NAME'] = ''

      super(env)
    else
      @app.call(env)
    end
  end

  private

    def public_output_path
      "/#{Frails.public_output_path}"
    end
end
