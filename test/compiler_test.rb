require 'test_helper'

class CompilerTest < Minitest::Test
  include SilenceLogger

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
    status = OpenStruct.new(success?: true)

    assert Frails.compiler.stale?
    Open3.stub :capture3, [:sterr, :stdout, status] do
      Frails.compiler.compile
      assert Frails.compiler.fresh?
    end
  end

  def test_freshness_on_compile_fail
    status = OpenStruct.new(success?: false)

    assert Frails.compiler.stale?
    Open3.stub :capture3, [:sterr, :stdout, status] do
      Frails.compiler.compile
      assert Frails.compiler.fresh?
    end
  end

  def test_compilation_digest_path
    assert_equal Frails.compiler.send(:compilation_digest_path).basename.to_s, "last-compilation-digest-#{Rails.env}"
  end
end
