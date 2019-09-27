# frozen_string_literal: true

require 'test_helper'

class ComponentTest < Minitest::Test
  include Frails::Component::TestHelpers

  def test_without_class
    result = render_inline(component: :without_class)

    assert_equal result.css('div').first.to_html, '<div>Without Class</div>'
  end

  def test_with_class
    result = render_inline(component: :with_class)

    assert_equal result.css('div').first.to_html, '<div>With Class</div>'
  end

  def test_with_class_argument
    result = render_inline(WithClassComponent)

    assert_equal result.css('div').first.to_html, '<div>With Class</div>'
  end

  def test_underscored_template
    result = render_inline(component: :underscored_template)

    assert_equal result.css('div').first.to_html, '<div>Underscored Template</div>'
  end

  def test_raises_error_when_component_is_missing
    exception = assert_raises NotImplementedError do
      render_inline(component: :missing_component)
    end

    assert_includes exception.message, 'Could not find a component for MissingComponent'
  end

  def test_raises_error_when_template_is_missing
    exception = assert_raises NotImplementedError do
      render_inline(component: :missing_template)
    end

    assert_includes exception.message, 'Could not find a template file for MissingTemplateComponent'
  end

  def test_checks_validations
    exception = assert_raises ActiveModel::ValidationError do
      render_inline(WrapperComponent)
    end

    assert_includes exception.message, "Content can't be blank"
  end

  def test_renders_content_from_block
    result = render_inline(WrapperComponent) do
      'content'
    end

    assert_equal result.css('span').first.to_html, '<span>content</span>'
  end

  def test_renders_erb_template
    result = render_inline(ErbComponent, message: 'bar') { 'foo' }

    assert_includes result.text, 'foo'
    assert_includes result.text, 'bar'
  end

  def test_renders_erb_template_with_hash_syntax
    result = render_inline(component: ErbComponent, locals: { message: 'bar' }) { 'foo' }

    assert_includes result.text, 'foo'
    assert_includes result.text, 'bar'
  end

  def test_renders_route_helper
    result = render_inline(component: :route)

    assert_includes result.text, '/'
  end

  def test_template_changes_are_not_reflected_in_production
    ActionView::Base.cache_template_loading = true

    assert_equal '<div>hello,world!</div>',
                 render_inline(component: :changed).css('div').first.to_html

    modify_file 'app/components/changed/index.html.erb', '<div>Goodbye world!</div>' do
      assert_equal '<div>hello,world!</div>',
                   render_inline(component: :changed).css('div').first.to_html
    end

    assert_equal '<div>hello,world!</div>',
                 render_inline(component: :changed).css('div').first.to_html
  end

  def test_template_changes_are_reflected_outside_production
    ActionView::Base.cache_template_loading = false

    assert_equal '<div>hello,world!</div>',
                 render_inline(component: :changed).css('div').first.to_html

    modify_file 'app/components/changed/index.html.erb', '<div>Goodbye world!</div>' do
      assert_equal '<div>Goodbye world!</div>',
                   render_inline(component: :changed).css('div').first.to_html
    end

    assert_equal '<div>hello,world!</div>',
                 render_inline(component: :changed).css('div').first.to_html
  end

  private

    def modify_file(file, content)
      filename = Rails.root.join(file)
      old_content = File.read(filename)
      begin
        File.open(filename, 'wb+') { |f| f.write(content) }
        yield
      ensure
        File.open(filename, 'wb+') { |f| f.write(old_content) }
      end
    end
end
