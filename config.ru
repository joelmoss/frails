# frozen_string_literal: true

require 'rubygems'
require 'bundler'

Bundler.require :default, :development

Combustion.path = 'test/dummy'
Combustion.initialize! :action_controller, :action_view do
  config.hosts << 'localhost'
end

run Combustion::Application
