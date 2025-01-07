module NdrUi
  module Bootstrap
    # This mixin provides Bootstrap breadcrumbs helper methods
    module BreadcrumbsHelper
      # Creates bootstrap breadcrumbs.
      #
      # ==== Signatures
      #
      #   bootstrap_breadcrumbs(breadcrumbs)
      #
      # ==== Examples
      #
      #   <%= bootstrap_breadcrumbs([
      #     bootstrap_breadcrumb("Fruits", "#fruits")
      #   ]) %>
      #   # => <ol class="breadcrumb">
      #          <li class="active"><a href="#fruits">Fruits</a></li>
      #        </ol>
      def bootstrap_breadcrumbs(breadcrumbs)
        content_tag('ol', safe_join(breadcrumbs), class: 'breadcrumb')
      end

      # Creates a bootstrap breadcrumb.
      #
      # ==== Signatures
      #
      #   bootstrap_breadcrumb(title, linkto, active: false)
      #
      # ==== Examples
      #
      #   <%= bootstrap_breadcrumb("Fruits", "#fruits", true) %>
      #   # => <li class="breadcrumb-item active"><a href="#fruits">Fruits</a></li>
      def bootstrap_breadcrumb(title, linkto, active = false)
        content_tag('li',
                    link_to(title, linkto),
                    { class: "breadcrumb-item#{active ? ' active' : ''}" })
      end
    end
  end
end
