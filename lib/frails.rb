# frozen_string_literal: true

require 'frails/version'
require 'active_support/core_ext/module'
require 'active_support/core_ext/module/attribute_accessors'

# ENV['FRAILS_DEV_SERVER_PORT'] ||= '8080'
# ENV['FRAILS_DEV_SERVER_HOST'] ||= 'localhost'
# ENV['FRAILS_PUBLIC_OUTPUT_PATH'] ||= 'assets'
# ENV['FRAILS_MANIFEST_PATH'] ||= 'manifest.json'

module Frails
  extend self

  def dev_server
    @dev_server ||= Frails::DevServer.new
  end

  def manifest
    @manifest ||= Frails::ManifestManager.new
  end

  def public_output_path
    ENV['FRAILS_PUBLIC_OUTPUT_PATH'] || 'assets'
  end

  def manifest_path
    ENV['FRAILS_MANIFEST_PATH'] || 'manifest.json'
  end
end

require 'frails/dev_server_proxy'
require 'frails/manifest_manager'
require 'frails/dev_server'
require 'frails/railtie'
