module SilenceLogger
  def setup
    Frails.logger = ActiveSupport::Logger.new('/dev/null')
  end
end
