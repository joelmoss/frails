# frozen_string_literal: true

require_relative 'dummy/config/environment'
require 'minitest/autorun'
require 'rails/test_help'
require 'byebug'
require 'frails/component/test_helpers'

Rails.env = 'production'
