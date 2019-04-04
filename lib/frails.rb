# frozen_string_literal: true

require 'frails/version'
require 'active_support/core_ext/module'
require 'active_support/core_ext/module/attribute_accessors'

module Frails
  extend self

  def instance=(instance)
    @instance = instance
  end

  def instance
    @instance ||= Frails::Instance.new
  end

  def with_node_env(env)
    original = ENV['NODE_ENV']
    ENV['NODE_ENV'] = env
    yield
  ensure
    ENV['NODE_ENV'] = original
  end

  delegate :manifest, :dev_server, to: :instance
end

require 'frails/instance'
require 'frails/dev_server_proxy'
require 'frails/manifest'
require 'frails/dev_server'
require 'frails/railtie'
