# frozen_string_literal: true

require 'test_helper'

class BlocksAssetsSystemTest < SystemTestCase
  test 'assets block' do
    visit '/blocks/assets/index'

    assert_page_snapshot
  end
end
