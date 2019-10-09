# frozen_string_literal: true

require_relative '../test/dummy/config/environment'
require 'rails/test_help'
require 'frails/component/test_helpers'

# Filter out the backtrace from minitest while preserving the one from other libraries.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

require 'rails/test_unit/reporter'
Rails::TestUnitReporter.executable = 'bin/test'

Rails.env = 'production'
