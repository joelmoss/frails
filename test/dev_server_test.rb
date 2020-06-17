# frozen_string_literal: true

require 'test_helper'

class DevServerTest < Minitest::Test
  def test_running?
    refute Frails.dev_server.running?
  end

  def test_host
    assert_equal Frails.dev_server.host, 'localhost'
    Frails.dev_server_host = 'mylocalhost'
    assert_equal Frails.dev_server.host, 'mylocalhost'
  end

  def test_port
    assert_equal Frails.dev_server.port, 8080
    Frails.dev_server_port = 8081
    assert_equal Frails.dev_server.port, 8081
  end
end
