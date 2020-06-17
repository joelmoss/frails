# frozen_string_literal: true

require_relative 'dummy/config/environment'
require 'minitest/autorun'
require 'rails/test_help'
require 'byebug'
require 'frails/component/test_helpers'

Rails.env = 'production'

class SystemTestCase < ActionDispatch::SystemTestCase
  Capybara.server = :webrick
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  def before_setup
    super

    @should_update_snapshots = ENV.fetch('UPDATE_SNAPSHOTS', false) != false
    @snapshot_assertion_counter = 0
    @snapshot_dir = File.join(FileUtils.pwd, 'test', 'snapshots')
  end

  def assert_page_snapshot(snapshot_name = nil)
    string = page.html
    snapshot_file = snapshot_path(self.class.name.underscore,
                                  snapshot_name || (@snapshot_assertion_counter += 1))

    if @should_update_snapshots && File.exist?(snapshot_file)
      FileUtils.mkdir_p(File.dirname(snapshot_file))

      File.open(snapshot_file, 'w') do |file|
        file.write(string)
      end

      puts "[snapshot] Updated #{self.class.name} (#{snapshot_file})"
    end

    assert_equal File.read(snapshot_file), string,
                 "Page does not match the snapshot (#{snapshot_file})"
  end

  private

    def snapshot_path(suite_name, snapshot_name)
      File.join @snapshot_dir, suite_name, "#{name}__#{snapshot_name}.snap.html"
    end
end
