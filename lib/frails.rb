# frozen_string_literal: true

require 'frails/version'
require 'active_support/core_ext/module'
require 'active_support/core_ext/module/attribute_accessors'

module Frails
  extend self

  def dev_server
    @dev_server ||= Frails::DevServer.new
  end

  def manifest
    @manifest ||= Frails::ManifestManager.new
  end

  # Path of where webpack build output will be emitted, relative to the Rails public directory.
  mattr_accessor :public_output_path
  @@public_output_path = 'assets'

  # Path and name of manifest file.
  mattr_accessor :manifest_path
  @@manifest_path = 'manifest.json'

  # Hostname where the Webpack dev webpack server should run.
  mattr_accessor :dev_server_host
  @@dev_server_host = 'localhost'

  # Post number where the Webpack dev webpack server should run.
  mattr_accessor :dev_server_port
  @@dev_server_port = 8080

  def config
    {
      public_output_path: @@public_output_path,
      dev_server_host: @@dev_server_host,
      dev_server_port: @@dev_server_port,
      manifest_path: @@manifest_path
    }
  end

  def config_as_json
    config.merge({ rails_env: Rails.env }).transform_keys { |key| key.to_s.camelize :lower }.to_json
  end

  def components_path
    @components_path ||= Rails.root.join('app', 'components')
  end
end

require 'frails/log_subscriber'
require 'frails/dev_server_proxy'
require 'frails/manifest_manager'
require 'frails/dev_server'
require 'frails/component'
require 'frails/railtie'
