module Frails
  class Runner
    def self.run(argv)
      $stdout.sync = true

      new(argv).run
    end

    def initialize(argv)
      @argv = argv

      @app_path = File.expand_path('.', Dir.pwd)
      @node_modules_bin_path = ENV['WEBPACK_NODE_MODULES_BIN_PATH'] || `yarn bin`.chomp
      @frails_config = @app_path + '/webpack.config.js'

      return if File.exist?(@frails_config)

      prompt = TTY::Prompt.new
      prompt.warn "\nFrails config '#{@frails_config}' not found.\n" \
                  'This is probably not what you want, so don\'t be surprised if ' \
                  "you get errors/warnings.\n"
    end
  end
end
