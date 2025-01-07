module NdrUi
  module Bootstrap
    # This provides bootstrap dropdown helper methods
    module DropdownHelper
      # Creates an html list item containing a link. It takes the standard link_to arguments
      # passing them through to a standard link_to call. For bootstrap styling, it simply adds the
      # class "active", if the link points to the current page that is being viewed.
      # Predominantly used by nav bars and lists.
      #
      # ==== Signatures
      #
      #   bootstrap_list_link_to(name, options = {}, html_options = nil)
      #   bootstrap_list_link_to(options = {}, html_options = nil) do
      #     # name
      #   end
      #
      # See the Rails documentation for details of the options and examples
      #
      def bootstrap_list_link_to(*args, &block)
        return bootstrap_list_link_to(capture(&block), (args.first || {}), args.second) if block_given?

        name         = args.first
        options      = args.second || {}
        html_options = args.third || {}

        klass = html_options[:class].to_s.split
        klass << if html_options.delete(:mode).to_s == 'nav'
                   'nav-link'
                 else
                   'dropdown-item'
                 end
        klass << 'active' if current_page?(options)
        html_options[:class] = klass.join(' ')

        content_tag(:li, link_to(name, options, html_options))
      end

      # Creates a Boostrap list header.
      #
      # ==== Signatures
      #
      #   bootstrap_list_header_tag(name)
      #
      # ==== Examples
      #
      #   <%= bootstrap_list_header_tag("Apples") %>
      #   # => <li class="dropdown-header">Apples</li>
      def bootstrap_list_header_tag(name, options = {})
        options[:class] = (options[:class].to_s.split + ['dropdown-header']).join(' ')
        content_tag(:li, content_tag(:h6, name, options))
      end

      # Creates a Boostrap list divider.
      #
      # ==== Signatures
      #
      #   bootstrap_list_divider_tag
      #
      # ==== Examples
      #
      #   <%= bootstrap_list_divider_tag %>
      #   # => <li><hr class="dropdown-divider"></li>
      def bootstrap_list_divider_tag
        content_tag(:li, content_tag(:hr, '', class: 'dropdown-divider'))
      end
    end
  end
end
