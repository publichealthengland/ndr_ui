require 'test_helper'

module NdrUi
  module Bootstrap
    # Test bootstrap breadcrumbs helpers
    class BreadcrumbsHelperTest < ActionView::TestCase
      test 'bootstrap_breadcrumbs' do
        assert_dom_equal '<ol class="breadcrumb"></ol>',
                         bootstrap_breadcrumbs([])
        assert_dom_equal '<ol class="breadcrumb"><li class="breadcrumb-item"><a href="#fruits">Fruits</a></li></ol>',
                         bootstrap_breadcrumbs([bootstrap_breadcrumb('Fruits', '#fruits')])
      end

      test 'bootstrap_breadcrumb' do
        assert_dom_equal '<li class="breadcrumb-item"><a href="#fruits">Fruits</a></li>',
                         bootstrap_breadcrumb('Fruits', '#fruits')
        assert_dom_equal '<li class="breadcrumb-item"><a href="#fruits">Fruits</a></li>',
                         bootstrap_breadcrumb('Fruits', '#fruits', false)
        assert_dom_equal '<li class="breadcrumb-item active"><a href="#fruits">Fruits</a></li>',
                         bootstrap_breadcrumb('Fruits', '#fruits', true)
      end
    end
  end
end
