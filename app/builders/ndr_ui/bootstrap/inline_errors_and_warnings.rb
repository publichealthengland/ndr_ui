module NdrUi
  module Bootstrap
    # Allows us to display errors and warnings in a bootstrap-friendly way
    module InlineErrorsAndWarnings
      # Tag::Base subclass for generating bootstrap span.form-text.
      # Allows us to use generate the tag_id properly.
      class HelpBlock < ActionView::Helpers::Tags::Base
        def render(&block)
          feedback_for =
            if respond_to?(:name_and_id_index, true)
              tag_id(name_and_id_index(@options))
            else
              add_default_name_and_id(@options.fetch('html', {}))
            end

          options = { class: 'form-text', data: { feedback_for: feedback_for } }
          content_tag(:span, @template_object.capture(&block), options)
        end
      end

      def self.add_inline_errors_and_warnings_to_field_helper(selector)
        define_method("#{selector}_with_inline_errors") do |method, *args, &block|
          html = send("#{selector}_without_inline_errors", method, *args, &block)
          return html + inline_errors_and_warnings(method)
        end
      end

      def self.included(base)
        excluded = [:label, :fields_for, :hidden_field]

        # Although highly unlikely, through the use of | in all_known_field_helpers),
        # uniq ensures we avoid a stack overflow
        (base.all_known_field_helpers - excluded).uniq.each do |selector|
          class_eval do
            add_inline_errors_and_warnings_to_field_helper(selector)
          end

          base.send(:alias_method, "#{selector}_without_inline_errors".to_sym, selector)
          base.send(:alias_method, selector, "#{selector}_with_inline_errors".to_sym)
        end
      end

      private

      def inline_errors_and_warnings(method)
        HelpBlock.new(object_name, method, @template, objectify_options(options)).render do
          ''.html_safe.tap do |buffer|
            if object_supports_errors?
              errors = @template.safe_join(object.errors[method], @template.tag(:br))
              buffer << @template.content_tag(:span, errors, class: 'text-danger')
            end

            if object_supports_warnings?
              warnings = @template.safe_join(object.warnings[method], @template.tag(:br))
              buffer << @template.content_tag(:span, warnings, class: 'text-warning')
            end
          end
        end
      end

      def object_supports_errors?
        object.respond_to?(:errors) && object.errors.respond_to?(:[])
      end

      def object_supports_warnings?
        object.respond_to?(:warnings) && object.warnings.respond_to?(:[])
      end
    end
  end
end
