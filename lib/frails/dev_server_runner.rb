require 'shellwords'
require 'socket'
require_relative 'dev_server'
require_relative 'runner'

module Frails
  class DevServerRunner < Frails::Runner
    def run
      dev_server = DevServer.new
      @hostname = dev_server.host
      @port = dev_server.port

      detect_port!
      execute_cmd
    end

    private

      # rubocop:disable Rails/Exit
      def detect_port!
        server = TCPServer.new(@hostname, @port)
        server.close
      rescue Errno::EADDRINUSE
        prompt = TTY::Prompt.new
        prompt.error "Another program is running on port #{@port}.\n" /
                     'Are you running this process somewhere else?'
        exit!
      end
      # rubocop:enable Rails/Exit

      def execute_cmd
        cmd = ['yarn', 'webpack-dev-server']
        cmd = ["#{@node_modules_bin_path}/webpack-dev-server"] if node_modules_bin_exist?
        cmd += ['--env', ENV['NODE_ENV']]

        Dir.chdir(@app_path) do
          Kernel.exec(*cmd)
        end
      end

      def node_modules_bin_exist?
        File.exist? "#{@node_modules_bin_path}/webpack-dev-server"
      end
  end
end
