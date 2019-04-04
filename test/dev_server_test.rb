# frozen_string_literal: true

require 'test_helper'

class DevServerTest < Frails::Test
  def test_running?
    refute Frails.dev_server.running?
  end

  def test_host
    with_rails_env('development') do
      assert_equal Frails.dev_server.host, 'localhost'
    end
  end

  def test_port
    with_rails_env('development') do
      assert_equal Frails.dev_server.port, 8080
    end
  end
end
