# frozen_string_literal: true

require_relative '../test/dummy/config/environment'
require 'frails/component/test_helpers'
require 'rails/test_help'

# Filter out the backtrace from minitest while preserving the one from other libraries.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

require 'rails/test_unit/reporter'
Rails::TestUnitReporter.executable = 'bin/test'

Rails.env = 'production'

def trim_result(html)
  html.delete(" \t\r\n")
end
