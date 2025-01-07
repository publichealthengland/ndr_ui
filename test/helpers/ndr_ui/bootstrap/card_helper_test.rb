require 'test_helper'

module NdrUi
  module Bootstrap
    # Test bootstrap card helpers
    class CardHelperTest < ActionView::TestCase
      test 'bootstrap_card_tag' do
        html = bootstrap_card_tag 'Apples', nil, type: 'warning', id: 'fruit' do
          'Check it out!!'
        end
        assert_dom_equal '<div id="fruit" class="card mb-3 bg-warning-subtle">' \
                         '<div class="card-header"><h4 class="card-title">Apples</h4></div>' \
                         'Check it out!!</div>',
                         html
      end

      test 'bootstrap_card_body_tag' do
        html = bootstrap_card_body_tag do
          'Check it out!!'
        end
        assert_dom_equal '<div class="card-body">Check it out!!</div>', html
      end
    end
  end
end
