module NdrUi
  module Bootstrap
    # This provides bootstrap accordion helper methods
    module AccordionHelper
      # Creates an accordion wrapper and creates a new NdrUi::Bootstrap::Accordion instance
      # Creates an plain or nested bootstrap accordion along with bootstrap_accordion_group
      # method at NdrUi::Bootstrap::Accordion class.
      #
      # ==== Signatures
      #
      #   bootstrap_accordion_tag(dom_id) do |accordion|
      #     #content for accordion items
      #   end
      #
      # ==== Examples
      #
      #   <%= bootstrap_accordion_group :fruit do |fruit_accordion| %>
      #   <% end %>
      #   # => <div id="fruit" class="accordion"></div>
      def bootstrap_accordion_tag(dom_id, options = {}, &_block)
        return unless block_given?

        options.stringify_keys!
        accordion = ::NdrUi::Bootstrap::Accordion.new(dom_id, self)
        seamless = options['seamless']
        content_tag(:div, id: accordion.dom_id.to_s, class: "accordion#{' accordion-flush' if seamless}") do
          yield(accordion)
        end
      end
    end

    # Creates a plain or nested bootstrap accordion along with bootstrap_accordion_tag helper
    # method.
    # Produce the inner html code of an accordion item.
    # Legacy styling recognised by jQuery UI and only fully supports one level accordion.
    #
    # ==== Signatures
    #
    #   bootstrap_accordion_tag(dom_id) do |accordion|
    #     accordion.bootstrap_accordion_group(heading, options) do
    #       #content or nested accordion
    #     end
    #   end
    #
    # ==== Options
    # * <tt>open: true</tt> - This will allow accordion item open by default
    # * <tt>seamless: true</tt> - This omits the panel-body container so that tables and lists
    #   can be seamless
    # * Accordion are using pre-defined html format, and options and html attributes
    #   are not accepted.
    #
    # ==== Examples
    #
    #   <%= bootstrap_accordion_tag :fruit do |fruit_accordion| %>
    #     <%= fruit_accordion.bootstrap_accordion_group "Apple" do %>
    #       This is an apple.
    #     <% end %>
    #     <%= fruit_accordion.bootstrap_accordion_group "Orange", open: true do %>
    #       This is an orange.
    #     <% end %>
    #   <% end %>
    #
    #   # =>
    #   <div id="fruit" class="accordion">
    #     <div class="panel panel-default">
    #       <div class="panel-heading">
    #         <a href="#fruit_1" data-bs-parent="#fruit" data-bs-toggle="collapse">Apple</a>
    #       </div>
    #       <div class="panel-collapse collapse" id="fruit_1">
    #         <div class="panel-body">
    #           This is an apple.
    #         </div>
    #       </div>
    #     </div>
    #     <div class="panel panel-default">
    #       <div class="panel-heading">
    #         <a href="#fruit_2" data-bs-parent="#fruit" data-bs-toggle="collapse">Orange</a>
    #       </div>
    #       <div class="panel-collapse collapse in" id="fruit_2">
    #         <div class="panel-body">
    #           This is an orange.
    #         </div>
    #       </div>
    #     </div>
    #   </div>
    #
    class Accordion
      attr_accessor :dom_id, :index

      # rubocop:disable Rails/HelperInstanceVariable
      def initialize(accordion_id, template)
        @dom_id = accordion_id
        @template = template
        @index = 0
      end

      def bootstrap_accordion_group(heading, options = {}, &block)
        return unless block_given?

        options.stringify_keys!
        @index += 1
        content = @template.content_tag('div', class: 'accordion-body') do
          @template.capture(&block)
        end
        @template.content_tag('div', class: 'accordion-item') do
          accordion_header_tag(heading, options['open']) + accordion_collapse_tag(content, options['open'])
        end
      end

      private

      def group_id
        "#{@dom_id}_#{@index}"
      end

      def accordion_header_tag(heading, open_by_default)
        @template.content_tag('h2', class: 'accordion-header') do
          @template.button_tag(heading,
                               class: "accordion-button#{' collapsed' unless open_by_default}",
                               type: :button,
                               'data-bs-toggle': 'collapse',
                               'data-bs-target': "##{group_id}")
        end
      end

      def accordion_collapse_tag(content, open_by_default)
        @template.content_tag('div', content,
                              id: group_id,
                              class: "accordion-collapse collapse#{' show' if open_by_default}",
                              'data-bs-parent': "##{@dom_id}")
      end
      # rubocop:enable Rails/HelperInstanceVariable
    end
  end
end
