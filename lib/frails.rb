# frozen_string_literal: true

require 'frails/version'
require 'active_support/core_ext/module'
require 'active_support/core_ext/module/attribute_accessors'

module Frails
  module_function

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

  def yarn_integrity_check!
    output = `yarn check --integrity && yarn check --verify-tree 2>&1`

    return if $CHILD_STATUS.success?

    require 'tty-prompt'
    prompt = TTY::Prompt.new

    prompt.error '=> Frails <============================='
    prompt.error 'Your Yarn packages are out of date!'
    prompt.error 'Please run `yarn install --check-files` to update.'
    prompt.error '========================================'
    prompt.error output

    exit(1)
  end

  delegate :manifest, :dev_server, to: :instance
end

require 'frails/instance'
require 'frails/dev_server_proxy'
require 'frails/manifest'
require 'frails/dev_server'
require 'frails/railtie'
