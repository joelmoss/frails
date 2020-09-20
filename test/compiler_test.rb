require 'test_helper'

class CompilerTest < Minitest::Test
  def remove_compilation_digest_path
    Frails.compiler.send(:compilation_digest_path).tap do |path|
      path.delete if path.exist?
    end
  end

  def setup
    remove_compilation_digest_path
  end

  def teardown
    remove_compilation_digest_path
  end

  def test_freshness
    assert Frails.compiler.stale?
    refute Frails.compiler.fresh?
  end

  def test_compile
    assert Frails.compiler.compile
  end

  def test_freshness_on_compile_success
    org_log_level = Frails.logger.level
    Frails.logger.level = Logger::FATAL

    status = OpenStruct.new(success?: true)

    assert Frails.compiler.stale?
    Open3.stub :capture3, [:stdout, :stderr, status] do
      Frails.compiler.compile
      assert Frails.compiler.fresh?
    end

    Frails.logger.level = org_log_level
  end

  def test_freshness_on_compile_fail
    org_log_level = Frails.logger.level
    Frails.logger.level = Logger::FATAL

    status = OpenStruct.new(success?: false)

    assert Frails.compiler.stale?
    Open3.stub :capture3, [:stdout, :stderr, status] do
      Frails.compiler.compile
      assert Frails.compiler.fresh?
    end

    Frails.logger.level = org_log_level
  end

  def test_compilation_digest_path
    assert_equal Frails.compiler.send(:compilation_digest_path).basename.to_s, "last-compilation-digest-#{Rails.env}"
  end
end
