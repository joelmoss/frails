# frozen_string_literal: true

require 'test_helper'

class DevServerTest < Minitest::Test
  def test_running?
    refute Frails.dev_server.running?
  end

  def test_host
    assert_equal 'localhost', Frails.dev_server.host
    Frails.dev_server_host = 'mylocalhost'
    assert_equal 'mylocalhost', Frails.dev_server.host
  end

  def test_port
    assert_equal 8080, Frails.dev_server.port
    Frails.dev_server_port = 8081
    assert_equal 8081, Frails.dev_server.port
  end
end
