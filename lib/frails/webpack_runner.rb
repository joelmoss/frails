require 'shellwords'
require_relative 'runner'

module Frails
  class FrailsRunner < Frails::Runner
    def run
      cmd = node_modules_bin_exist? ? ["#{@node_modules_bin_path}/webpack"] : %w[yarn webpack]
      cmd += ['--env', ENV['NODE_ENV']]
      cmd += @argv

      Dir.chdir(@app_path) do
        Kernel.exec(*cmd)
      end
    end

    private

      def node_modules_bin_exist?
        File.exist? "#{@node_modules_bin_path}/webpack"
      end
  end
end
