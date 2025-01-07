require 'test_helper'

module NdrUi
  module Bootstrap
    # Test bootstrap dropdown helpers
    class DropdownHelperTest < ActionView::TestCase
      test 'bootstrap_list_link_to' do
        stubs(:inbox_path).returns('/inbox')
        stubs(:current_page?).returns(false)
        refute current_page?(inbox_path)
        assert_dom_equal "<li>#{link_to('test', inbox_path, class: 'dropdown-item')}</li>",
                         bootstrap_list_link_to('test', inbox_path)
        assert_dom_equal "<li>#{link_to('block', inbox_path, class: 'dropdown-item')}</li>",
                         bootstrap_list_link_to(inbox_path) { 'block' }
        stubs(:current_page?).returns(true)
        assert current_page?(inbox_path)
        assert_dom_equal "<li>#{link_to('test', inbox_path, class: 'dropdown-item active')}</li>",
                         bootstrap_list_link_to('test', inbox_path)
      end

      test 'bootstrap_list_header_tag' do
        assert_dom_equal '<li><h6 class="dropdown-header">Apples</h6></li>',
                         bootstrap_list_header_tag('Apples')
        assert bootstrap_list_header_tag(unsafe_string).html_safe?,
               'bootstrap_list_header_tag is not html_safe'
      end

      test 'bootstrap_list_divider_tag' do
        assert_dom_equal '<li><hr class="dropdown-divider"></hr></li>',
                         bootstrap_list_divider_tag
        assert bootstrap_list_divider_tag.html_safe?, 'bootstrap_list_divider_tag is not html_safe'
      end
    end
  end
end
