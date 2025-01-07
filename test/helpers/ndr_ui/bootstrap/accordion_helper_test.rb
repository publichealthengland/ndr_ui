require 'test_helper'

module NdrUi
  module Bootstrap
    # Test bootstrap accordion helpers
    class AccordionHelperTest < ActionView::TestCase
      test 'bootstrap_accordion_tag' do
        html = bootstrap_accordion_tag :fruit do |fruit_accordion|
          inner_html = fruit_accordion.bootstrap_accordion_group 'Apple' do
            'This is an apple.'
          end
          inner_html += fruit_accordion.bootstrap_accordion_group 'Orange', open: true do
            'This is an orange.'
          end
          inner_html
        end
        assert_dom_equal '<div id="fruit" class="accordion">' \
                         '<div class="accordion-item"><h2 class="accordion-header">' \
                         '<button name="button" type="button" class="accordion-button collapsed" ' \
                         'data-bs-toggle="collapse" data-bs-target="#fruit_1">Apple</button></h2>' \
                         '<div id="fruit_1" class="accordion-collapse collapse" data-bs-parent="#fruit">' \
                         '<div class="accordion-body">This is an apple.</div></div></div>' \
                         '<div class="accordion-item"><h2 class="accordion-header">' \
                         '<button name="button" type="button" class="accordion-button" ' \
                         'data-bs-toggle="collapse" data-bs-target="#fruit_2">Orange</button></h2>' \
                         '<div id="fruit_2" class="accordion-collapse collapse show" data-bs-parent="#fruit">' \
                         '<div class="accordion-body">This is an orange.</div></div></div></div>',
                         html
      end

      test 'bootstrap_accordion_tag with seamless option' do
        html = bootstrap_accordion_tag :fruit, seamless: true do |fruit_accordion|
          fruit_accordion.bootstrap_accordion_group 'Apple' do
            'This is an apple.'
          end
        end
        assert_dom_equal '<div id="fruit" class="accordion accordion-flush"><div class="accordion-item">' \
                         '<h2 class="accordion-header"><button name="button" type="button" ' \
                         'class="accordion-button collapsed" data-bs-toggle="collapse" data-bs-target="#fruit_1">' \
                         'Apple</button></h2>' \
                         '<div id="fruit_1" class="accordion-collapse collapse" data-bs-parent="#fruit">' \
                         '<div class="accordion-body">This is an apple.</div></div></div></div>',
                         html
      end
    end
  end
end
