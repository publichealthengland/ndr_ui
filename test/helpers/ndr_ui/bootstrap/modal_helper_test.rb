require 'test_helper'

module NdrUi
  module Bootstrap
    # Test bootstrap modal helpers
    class ModalHelperTest < ActionView::TestCase
      test 'bootstrap_modal_dialog_tag' do
        @output_buffer = bootstrap_modal_dialog_tag { 'Pear form' }
        assert_select 'div.modal-dialog[role=document]' do
          assert_select 'div.modal-content', 'Pear form'
        end

        reset_output_buffer!
        @output_buffer = bootstrap_modal_dialog_tag(size: 'lg') { 'Pear form' }
        assert_select 'div.modal-dialog.modal-lg' do
          assert_select 'div.modal-content', 'Pear form'
        end
      end

      test 'bootstrap_modal_header_tag' do
        assert_dom_equal(
          '<div class="modal-header"><h4 class="modal-title">Check it out!!</h4></div>',
          bootstrap_modal_header_tag { 'Check it out!!' }
        )

        assert_dom_equal(
          '<div class="modal-header"><h4 class="modal-title">Check it out!!</h4></div>',
          bootstrap_modal_header_tag('Check it out!!')
        )

        @output_buffer = bootstrap_modal_header_tag('Check it out!!', dismissible: true)
        assert_select 'div.modal-header' do
          assert_select 'button',
                        attributes: {
                          type: 'button', class: 'btn-close', 'data-bs-dismiss': 'modal',
                          'aria-label': 'Close'
                        } do
            assert_select 'span',
                          attributes: { 'aria-hidden': 'true' },
                          text: Nokogiri::HTML.parse('&times;').text
          end
          assert_select 'h4.modal-title', 'Check it out!!'
        end
      end

      test 'bootstrap_modal_body_tag' do
        assert_dom_equal '<div class="modal-body">Check it out!!</div>',
                         bootstrap_modal_body_tag { 'Check it out!!' }

        assert_dom_equal '<div class="modal-body">Check it out!!</div>',
                         bootstrap_modal_body_tag('Check it out!!')
      end

      test 'bootstrap_modal_footer_tag with default button label' do
        @output_buffer = bootstrap_modal_footer_tag('Non-readonly button text', readonly: true)
        assert_select 'div.modal-footer' do
          assert_select 'button.btn.btn-default',
                        attributes: { 'data-bs-dismiss': 'modal' },
                        text: 'Close'
        end

        reset_output_buffer!
        @output_buffer = bootstrap_modal_footer_tag('Non-readonly button text', readonly: false)
        assert_select 'div.modal-footer' do
          assert_select 'button.btn.btn-default',
                        attributes: { 'data-bs-dismiss': 'modal' },
                        text: 'Non-readonly button text'
        end
      end

      test 'bootstrap_modal_footer_tag with block content' do
        @output_buffer = bootstrap_modal_footer_tag(readonly: true) do
          button_tag('Non-readonly default', class: 'btn btn-default', 'data-bs-dismiss': 'modal') +
            button_tag('Non-readonly primary', class: 'btn btn-primary', 'data-bs-dismiss': 'modal')
        end
        assert_select 'div.modal-footer' do
          assert_select 'button.btn.btn-default',
                        attributes: { 'data-bs-dismiss': 'modal' },
                        text: 'Close'
        end

        reset_output_buffer!
        @output_buffer = bootstrap_modal_footer_tag(readonly: false) do
          button_tag('Non-readonly default', class: 'btn btn-default', 'data-bs-dismiss': 'modal') +
            button_tag('Non-readonly primary', class: 'btn btn-primary', 'data-bs-dismiss': 'modal')
        end
        assert_select 'div.modal-footer' do
          assert_select 'button.btn.btn-default',
                        attributes: { 'data-bs-dismiss': 'modal' },
                        text: 'Non-readonly default'
          assert_select 'button.btn.btn-primary',
                        attributes: { 'data-bs-dismiss': 'modal' },
                        text: 'Non-readonly primary'
        end
      end

      test 'bootstrap_modal_footer_tag with default content' do
        @output_buffer = bootstrap_modal_footer_tag(readonly: true)
        assert_select 'div.modal-footer' do
          assert_select 'button.btn.btn-default',
                        attributes: { 'data-bs-dismiss': 'modal' },
                        text: 'Close'
        end

        reset_output_buffer!
        @output_buffer = bootstrap_modal_footer_tag(readonly: false)
        assert_select 'div.modal-footer' do
          assert_select 'button.btn.btn-default',
                        attributes: { 'data-bs-dismiss': 'modal' },
                        html: /Don(.*?)t save/ # assert_select behaviour changes
          assert_select 'input.btn.btn-primary',
                        attributes: { type: 'submit', 'data-bs-dismiss': 'modal' },
                        value: 'Save'
        end
      end

      test 'bootstrap_modal_box' do
        @output_buffer = bootstrap_modal_box('New Pear', 'Pear form')
        assert_select 'div.modal-dialog' do
          assert_select 'div.modal-content' do
            assert_select 'div.modal-header h4', 'New Pear'
            assert_select 'div.modal-body', 'Pear form'
            assert_select 'div.modal-footer' do
              assert_select 'button',
                            attributes: { class: 'btn btn-default', 'data-bs-dismiss': 'modal' },
                            html: /Don(.*?)t save/ # assert_select behaviour changes
              assert_select 'input.btn.btn-primary[type=submit]'
            end
          end
        end

        reset_output_buffer!
        @output_buffer = bootstrap_modal_box('New Pear') { 'Pear form' }
        assert_select 'div.modal-dialog' do
          assert_select 'div.modal-content' do
            assert_select 'div.modal-header h4', 'New Pear'
            assert_select 'div.modal-body', 'Pear form'
            assert_select 'div.modal-footer' do
              # assert_select behaviour changes:
              assert_select 'button.btn.btn-default[data-bs-dismiss=modal]', html: /Don(.*?)t save/
              assert_select 'input.btn.btn-primary[type=submit]'
            end
          end
        end
      end

      test 'bootstrap_modal_box with readonly option' do
        @output_buffer = bootstrap_modal_box('New Pear', 'Pear form', readonly: true)
        assert_select 'div.modal-dialog' do
          assert_select 'div.modal-content' do
            assert_select 'div.modal-header h4', 'New Pear'
            assert_select 'div.modal-body', 'Pear form'
            assert_select 'div.modal-footer' do
              assert_select 'button.btn.btn-default[data-bs-dismiss=modal]', html: 'Close'
            end
          end
        end

        reset_output_buffer!
        @output_buffer = bootstrap_modal_box('New Pear', 'Pear form', readonly: false)
        assert_select 'div.modal-dialog' do
          assert_select 'div.modal-content' do
            assert_select 'div.modal-header h4', 'New Pear'
            assert_select 'div.modal-body', 'Pear form'
            assert_select 'div.modal-footer' do
              # assert_select behaviour changes:
              assert_select 'button.btn.btn-default[data-bs-dismiss=modal]', html: /Don(.*?)t save/
              assert_select 'input.btn.btn-primary[type=submit]'
            end
          end
        end
      end

      test 'bootstrap_modal_box with size' do
        @output_buffer = bootstrap_modal_box('New Pear', 'Pear form', size: 'lg')
        assert_select 'div.modal-dialog.modal-lg'

        reset_output_buffer!
        @output_buffer = bootstrap_modal_box('New Pear', size: 'lg') { 'Pear form' }
        assert_select 'div.modal-dialog.modal-lg'

        reset_output_buffer!
        @output_buffer = bootstrap_modal_box('New Pear', 'Pear form', size: 'enormous')
        assert_select 'div.modal-dialog.modal-enormous', 0
      end
    end
  end
end
