install_template_path = File.expand_path("../install/template.rb", __dir__).freeze
bin_path = ENV['BUNDLE_BIN'] || './bin'

namespace :frails do
  desc 'Install Frails in this application'
  task install: [:check_node, :check_yarn] do
    exec "#{RbConfig.ruby} #{bin_path}/rails app:template LOCATION=#{install_template_path}"
  end
end
