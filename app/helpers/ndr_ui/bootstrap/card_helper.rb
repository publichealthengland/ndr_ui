module NdrUi
  module Bootstrap
    # This provides accordion
    module CardHelper
      include CssHelper

      CARD_TYPES = %w[primary secondary success danger warning info light dark].freeze

      # Creates a bootstrap card wrapper. the heading is wrapped in a card-header.
      # The content is not wrapped in a card-body to enable seamless tables and lists.
      #
      # ==== Signatures
      #
      #   bootstrap_card_tag(heading, options = {}) do
      #     #content for card
      #   end
      #
      # ==== Examples
      #
      #   <%= bootstrap_card_tag 'Apples', type: :warning, id: 'fruit' do %>
      #     Check it out!!
      #   <% end %>
      #   # => <div id="fruit" class="card mb-3 text-bg-warning">
      #          <div class="card-header d-flex">
      #            <h4 class="card-title">Apples</h4>
      #            <div class="ms-auto"></div>
      #          </div>
      #          Check it out!!
      #        </div>
      def bootstrap_card_tag(heading, controls = nil, options = {}, &block)
        return unless block_given?

        options.stringify_keys!
        classes = %w[card mb-3]
        classes << "bg-#{options.delete('type')}-subtle" if CARD_TYPES.include?(options['type'].to_s)
        options = css_class_options_merge(options, classes)

        header = content_tag(:div, class: "card-header#{' d-flex' if controls.present?}") do
          concat content_tag(:h4, heading, class: 'card-title')
          concat content_tag(:div, controls, class: 'ms-auto') if controls.present?
        end

        content_tag(:div, header + capture(&block), options)
      end

      # Creates a simple bootstrap card body.
      #
      # ==== Signatures
      #
      #   bootstrap_card_body_tag do
      #     #content for card body
      #   end
      #
      # ==== Examples
      #
      #   <%= bootstrap_card_body_tag do %>
      #     Check it out!!
      #   <% end %>
      #   # => <div class="card-body">Check it out!!</div>
      def bootstrap_card_body_tag(&block)
        return unless block_given?

        content_tag(:div, capture(&block), class: 'card-body')
      end

      # Creates a bootstrap card wrapper. the heading is wrapped in a card-header.
      # The content is wrapped in a ul.list-group to enable seamless lists.
      # It doesn't support controls (controls = nil).
      def bootstrap_card_list(title, options = {}, &block)
        bootstrap_card_tag(title, nil, options) do
          content_tag(:div, capture(&block), class: 'list-group list-group-flush')
        end
      end

      # Bootstrap v4 dropped Wells for Card component
      # create a wrapper for Wells - a Card without heading
      def bootstrap_well_tag(options = {}, &block)
        return unless block_given?

        options.stringify_keys!
        classes = %w[card mb-3]
        classes << (CARD_TYPES.include?(options['type'].to_s) ? "bg-#{options.delete('type')}-subtle" : 'text-bg-light')
        classes += options['class'].to_s.split if options['class'].present?
        options['class'] = classes.uniq.join(' ')

        content_tag(:div, options) do
          bootstrap_card_body_tag do
            capture(&block)
          end
        end
      end
    end
  end
end
