# frozen_string_literal: true

class Frails::Instance
  def dev_server
    @dev_server ||= Frails::DevServer.new
  end

  def manifest
    @manifest ||= Frails::Manifest.new
  end
end
