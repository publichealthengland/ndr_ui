module NdrUi
  module Bootstrap
    # This provides bootstrap modal box helper methods
    module ModalHelper
      MODAL_SIZES = %w(sm lg).freeze

      # Creates a bootstrap modal dialog wrapper. the content is wrapped in a modal-content.
      #
      # ==== Signatures
      #
      #   bootstrap_modal_dialog_tag(options = {}) do
      #     # content for modal
      #   end
      #
      # ==== Examples
      #
      #   <%= bootstrap_modal_tag size: 'lg', id: 'fruit' do %>
      #     Check it out!!
      #   <% end %>
      #   # =>
      #   <div id="fruit" class="modal modal-lg">
      #     <div class="modal-content">Check it out!!</div>
      #   </div>
      def bootstrap_modal_dialog_tag(options = {}, &block)
        return unless block_given?

        content_tag(:div, class: bootstrap_modal_classes(options), role: 'document') do
          content_tag(:div, capture(&block), class: 'modal-content')
        end
      end

      # Creates a simple bootstrap modal header.
      #
      # ==== Signatures
      #
      #   bootstrap_modal_header_tag(content, options = {})
      #   bootstrap_modal_header_tag(options = {}) do
      #     # content for modal header
      #   end
      #
      # ==== Options
      # * <tt>dismissible: false</tt> - This will set whether or not a close X button
      #   will appear, allowing the modal box to be dismissed by the user. Defaults to false.
      #
      # ==== Examples
      #
      #   <%= bootstrap_modal_header_tag do %>
      #     Check it out!!
      #   <% end %>
      #   # => <div class="modal-header">Check it out!!</div>
      def bootstrap_modal_header_tag(*args, &block)
        return bootstrap_modal_header_tag(capture(&block), *args) if block_given?

        options = args.extract_options!
        options.stringify_keys!

        # unless options.include?('dismissible') && !options['dismissible']
        #   options['dismissible'] = true
        # end

        heading = content_tag(:h4, args.first, class: 'modal-title')
        if options.delete('dismissible')
          heading = button_tag(content_tag(:span, '×', 'aria-hidden': 'true'),
                               type: 'button', class: 'btn-close', 'data-bs-dismiss': 'modal',
                               'aria-label': 'Close') + heading
        end
        content_tag(:div, heading, class: 'modal-header')
      end

      # Creates a simple bootstrap modal body.
      #
      # ==== Signatures
      #
      #   bootstrap_modal_body_tag(content)
      #   bootstrap_modal_body_tag do
      #     # content for modal body
      #   end
      #
      # ==== Examples
      #
      #   <%= bootstrap_modal_body_tag do %>
      #     Check it out!!
      #   <% end %>
      #   # => <div class="modal-body">Check it out!!</div>
      def bootstrap_modal_body_tag(*args, &block)
        return bootstrap_modal_body_tag(capture(&block), *args) if block_given?

        content_tag(:div, args.first, class: 'modal-body')
      end

      # Creates a simple bootstrap modal footer. If called with a content block, that block
      # defines the non-readonly button(s). Alternatively, if called with a label first parameter,
      # then a default button is created with that label. If no block or label is defined, then
      # the default "Don't save" and "Save" buttons are returned.
      #
      # ==== Signatures
      #
      #   bootstrap_modal_footer_tag(options = {}) do
      #     # content for modal footer
      #   end
      #   bootstrap_modal_footer_tag(default_button_label, options = {})
      #   bootstrap_modal_footer_tag(options = {})
      #
      # ==== Options
      # * <tt>readonly: false</tt> - This will set whether or not a close button
      #   will appear in the footer, regardless of the buttons defined in the label/block.
      #   Defaults to false.
      #
      # ==== Examples
      #
      #   <%= bootstrap_modal_footer_tag('Button text', readonly: true)
      #   # =>
      #   <div class="modal-footer">
      #     <button name="button" type="submit" class="btn btn-default" data-bs-dismiss="modal">
      #       Close
      #     </button>
      #   </div>
      #
      #   <%= bootstrap_modal_footer_tag(readonly: false) do
      #     button_tag('Non-readonly default', class: 'btn btn-default', 'data-bs-dismiss': 'modal') +
      #       button_tag('Non-readonly primary', class: 'btn btn-primary', 'data-bs-dismiss': 'modal')
      #   end %>
      #   # =>
      #   <div class="modal-footer">
      #     <button name="button" type="submit" class="btn btn-default" data-bs-dismiss="modal">
      #       Non-readonly default
      #     </button>
      #     <button name="button" type="submit" class="btn btn-primary" data-bs-dismiss="modal">
      #       Non-readonly primary
      #     </button>
      #   </div>
      #
      #   <%= bootstrap_modal_footer_tag('Button text') %>
      #   # =>
      #   <div class="modal-footer">
      #     <button name="button" type="submit" class="btn btn-default" data-bs-dismiss="modal">
      #       Button text
      #     </button>
      #   </div>
      #
      #   <%= bootstrap_modal_footer_tag %>
      #   # =>
      #   <div class="modal-footer">
      #     <button name="button" type="submit" class="btn btn-default" data-bs-dismiss="modal">
      #       Don&#39;t save
      #     </button>
      #     <input type="submit" name="commit" value="Save" class="btn btn-primary"
      #       disable_with="Saving&hellip;" data-disable-with="Save" />
      #   </div>
      def bootstrap_modal_footer_tag(*args, &block)
        options = args.extract_options!
        options.stringify_keys!

        content_tag(:div, class: 'modal-footer') do
          if options['readonly']
            bootstrap_modal_button('Close')
          elsif block_given?
            capture(&block)
          elsif args.first
            bootstrap_modal_button(args.first)
          else
            bootstrap_modal_save_buttons
          end
        end
      end

      # Creates a Boostrap Modal box.
      #
      # ==== Signatures
      #
      #   bootstrap_modal_box(title, controls, options = {})
      #   bootstrap_modal_box(title, options = {}) do
      #     # controls
      #   end
      #
      # ==== Options
      #
      # * <tt>:size</tt> - Symbol of modal box size. Supported sizes are <tt>:sm</tt>,
      #   <tt>:lg</tt>. By default it will be unset (medium width).
      #
      # ==== Examples
      #
      #   <%= bootstrap_modal_box("New Pear", "Pear form") %>
      #   # =>
      #   <div class="modal-dialog">
      #     <div class="modal-content">
      #       <div class="modal-header">
      #         <h4 class="modal-title">New Pear</h4>
      #       </div>
      #       <div class="modal-body">
      #         Pear form
      #       </div>
      #       <div class="modal-footer">
      #         <button type="button" class="btn btn-default" data-bs-dismiss="modal">
      #           Don't save
      #         </button>
      #         <input name="commit" class="btn-primary btn" data-disable-with="Saving&hellip;"
      #   value="Save" type="submit" />
      #       </div>
      #     </div>
      #   </div>
      def bootstrap_modal_box(title, *args, &block)
        return bootstrap_modal_box(title, capture(&block), *args) if block_given?
        options = args.extract_options!

        bootstrap_modal_dialog_tag(options) do
          bootstrap_modal_header_tag(title) +
            bootstrap_modal_body_tag(args.first) +
            bootstrap_modal_footer_tag(options)
        end
      end

      def bootstrap_modal_save_buttons
        bootstrap_modal_button("Don't save") +
          submit_tag('Save',
                     class: 'btn btn-primary',
                     disable_with: 'Saving&hellip;'.html_safe)
      end

      def bootstrap_modal_button(label)
        button_tag(label, class: 'btn btn-default', 'data-bs-dismiss': 'modal')
      end

      private

      # Returns the css classes for a bootstrap modal dialog
      def bootstrap_modal_classes(options)
        options = options.stringify_keys

        classes = %w(modal-dialog)
        classes << "modal-#{options['size']}" if MODAL_SIZES.include?(options['size'])
        classes.join(' ')
      end
    end
  end
end
