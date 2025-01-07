module NdrUi
  module Bootstrap
    # Provides a form builder method for the datepicker plugin
    module Datepicker
      # Creates a Boostrap datepicker field.
      #
      # ==== Signature
      #
      #  datepicker_field(method, options = {})
      #
      # ==== Example
      #
      #  <%= form.datepicker_field(:last_updated, no_future: true) %>
      #  # => <div class="input-group date" data-provide="datepicker" data-date-end-date="0d">
      #         <input class="form-control" type="text"
      #           name="post[last_updated]" id="post_last_updated" />
      #         <span aria-hidden="true" class="input-group-text">
      #           <span class="glyphicon glyphicon-calendar"></span>
      #         </span>
      #       </div>
      #       <span class="form-text" data-feedback-for="post_last_updated">
      #         <span class="text-danger"></span><span class="text-warning"></span>
      #       </span>
      #
      def datepicker_field(method, options = {})
        date_value = object.send(method).try(:to_date).try(:to_formatted_s, :ui)

        defaults = {
          value:          date_value,
          readonly_value: date_value
        }

        date_input_group(method, defaults.deep_merge!(options))
      end

      private

      # This method returns the date input-group and inline errors and warnings.
      # The errors and warnings are appended after the group to avoid messing up the
      # input-group-text calendar icon.
      def date_input_group(method, options)
        data = { provide: 'datepicker' }
        data[:'date-end-date'] = '0d' if options.delete(:no_future)

        html   = text_field_without_inline_errors(method, options)
        errors = inline_errors_and_warnings(method)
        return html + errors if readonly?

        @template.content_tag(:div, class: 'input-group date', data: data) do
          html +
            @template.content_tag(:span,
                                  @template.bootstrap_icon_tag(:calendar),
                                  'aria-hidden': 'true', class: 'input-group-text')
        end + errors
      end
    end
  end
end
