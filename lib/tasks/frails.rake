# frozen_string_literal: true

require 'open3'

install_template_path = File.expand_path('../install/template.rb', __dir__).freeze
bin_path = ENV['BUNDLE_BIN'] || './bin'

namespace :frails do
  desc 'Install Frails in this application'
  task :install do
    exec "#{RbConfig.ruby} #{bin_path}/rails app:template LOCATION=#{install_template_path}"
  end

  desc 'Compile JavaScript packs using webpack for production with digests'
  task compile: :environment do
    puts 'Compiling Webpack...'

    ENV['RAILS_ENV'] ||= 'development'
    stdout, sterr, status = Open3.capture3({}, "yarn webpack --env #{ENV['RAILS_ENV']}")

    if sterr == '' && status.success?
      puts 'Frails successfully compiled 🎉'
    else
      puts "Frails failed compilation\n#{sterr}\n#{stdout}"
    end
  end
end

# Compile packs after we've compiled all other assets during precompilation
if Rake::Task.task_defined?('assets:precompile')
  Rake::Task['assets:precompile'].enhance do
    Rake::Task['frails:compile'].invoke
  end
else
  Rake::Task.define_task('assets:precompile' => ['frails:compile'])
  Rake::Task.define_task('assets:clean') # null task just so Heroku builds don't fail
end
