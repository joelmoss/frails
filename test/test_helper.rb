# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'minitest/autorun'
require 'rails'
require 'rails/test_help'

require_relative 'test_app/config/environment'

Rails.env = 'production'
