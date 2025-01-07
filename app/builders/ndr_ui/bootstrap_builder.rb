module NdrUi
  # Our Bootstrp FormBuilder subclass
  class BootstrapBuilder < ActionView::Helpers::FormBuilder
    # FormBuilder defines `field_helpers`, but it is not an exhaustive
    # list; here, add any others that we may want to be aware of.
    def self.all_known_field_helpers
      field_helpers | field_helpers_from_form_options_helper | field_helpers_from_date_helper
    end

    def self.field_helpers_from_form_options_helper
      [:select, :collection_select, :grouped_collection_select,
       :time_zone_select, :collection_check_boxes, :collection_radio_buttons]
    end

    def self.field_helpers_from_date_helper
      [:date_select, :time_select, :datetime_select]
    end

    include CssHelper
    include ::NdrUi::Bootstrap::FormControlClass
    include ::NdrUi::Bootstrap::Readonly
    include ::NdrUi::Bootstrap::InputGroupAddons
    include ::NdrUi::Bootstrap::InlineErrorsAndWarnings
    include ::NdrUi::Bootstrap::Datepicker
    include ::NdrUi::Bootstrap::ErrorAndWarningAlertBoxes
    include ::NdrUi::Bootstrap::LabelTooltips

    attr_accessor :horizontal_mode

    # Creates a bootstrap control group with label tag for the specified method (and has a direct
    # equivalent in the legacy CautionBuilder). It automatically applies the error or warning class
    # to the control group if the method has errors.
    #
    # ==== Signatures
    #
    #   control_group(method, text=nil, options={}, control_options={}, controls)
    #   control_group(method, text=nil, options={}, control_options={}) do
    #     # controls
    #   end
    #
    # ==== Options
    # * <tt>options</tt> - These are standard options that are applied to the overall form-group
    #   div tag. Options include <tt>:id</tt> and <tt>:class</tt>
    # * <tt>control_options</tt> - These are standard options that are applied to the controls
    #   div tag.
    #
    # ==== Examples
    #
    # TODO: `.form-group` class (margin-left & margin-right : -15px) and `.col-*-*` class (padding-left & padding-right : 15px) should be nested in order to get the correct layout.

    #   <%= form.control_group(:title, 'Demo', {:class => "col-md-6"}, {:id => 'some_id'}, "# Controls go here") %>
    #   # => <div class="form-group col-md-6">
    #           <label class="form-label" for="post_title">Demo</label>
    #           <div id="some_id">
    #             # Controls go here
    #           </div>
    #         </div>
    #
    # You can use a block as well if your alert message is hard to fit into the message parameter. ERb example:
    #
    #   <%= form.control_group(:title, 'Demo', {:class => "col-md-6"}, {:id => 'some_id'}) do %>
    #     # Controls go here
    #   <% end %>
    #
    def control_group(methods, text = nil, options = {}, control_options = {}, controls = '', &block)
      return control_group(methods, text, options, control_options, @template.capture(&block)) if block_given?

      methods = [methods].compact unless methods.is_a?(Array)

      label_classes = if horizontal_mode
                        "col-form-label col-#{label_columns} text-end"
                      else
                        'form-label'
                      end
      label_options = {
        class: label_classes,
        tooltip: options.delete(:tooltip)
      }
      label_html = if methods.present?
                     label(methods.first, text, label_options)
                   else
                     @template.content_tag(:span, text, class: label_classes)
                   end

      control_options = css_class_options_merge(control_options) do |control_classes|
        # Only add a col-md-N class if none already specified
        if horizontal_mode && control_classes.none? { |css_class| css_class.start_with?('col-') }
          control_classes << "col-#{12 - label_columns}"
        end
      end

      @template.content_tag(:div,
                            label_html +
                              @template.content_tag(:div, controls, control_options),
                            control_group_options(methods, options))
    end

    def control_group_options(methods, options)
      # .form-group has been deprecated in Bootstrap
      # however, we keep this class to do the global margin setting
      default_classes = %w[form-group]
      default_classes << 'row' if horizontal_mode
      css_class_options_merge(options, default_classes) do |group_classes|
        if object && methods.present?
          if methods.any? { |method| object.errors[method].present? }
            group_classes << 'has-error'
          elsif object.respond_to?(:warnings) && methods.any? { |method| object.warnings[method].present? }
            group_classes << 'has-warning'
          end
        end
      end
    end
    private :control_group_options

    # if horizontal_mode is true the label_columns defaults to 3 columns
    def label_columns
      horizontal_mode === true ? 3 : horizontal_mode
    end

    # Lastly we run the bootstrap_builder hooks
    ActiveSupport.run_load_hooks(:bootstrap_builder, self)
  end
end
