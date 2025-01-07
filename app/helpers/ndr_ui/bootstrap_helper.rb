module NdrUi
  # Provides helper methods for the Twitter Bootstrap framework
  module BootstrapHelper # rubocop:disable Metrics/ModuleLength
    include ::NdrUi::Bootstrap::AccordionHelper
    include ::NdrUi::Bootstrap::BreadcrumbsHelper
    include ::NdrUi::Bootstrap::CardHelper
    include ::NdrUi::Bootstrap::DropdownHelper
    include ::NdrUi::Bootstrap::ModalHelper

    TYPE_STYLE_MAP = {
      important: :danger,
      default: :secondary
    }.freeze

    # Creates an alert box of the given +type+. It supports the following alert box types
    # <tt>:alert</tt>, <tt>:danger</tt>, <tt>:info</tt> and <tt>:success</tt>.
    #
    # ==== Signatures
    #
    #   bootstrap_alert_tag(type, message, options = {})
    #   bootstrap_alert_tag(type, options = {}) do
    #     # message
    #   end
    #
    # ==== Options
    # * <tt>dismissible: true</tt> - This will set whether or not a close X button
    #   will appear, allowing the alert box to be dismissed by the user. This is only
    #   supported with the Bootstrap layout and defaults to true.
    #   link to open in a popup window. By passing true, a default browser window
    #   will be opened with the URL. You can also specify an array of options
    #   that are passed-thru to JavaScripts window.open method.
    # * All remaining options are treated as html attributes for the containing div tag.
    #   The class attribute is overwritten by the helper and so will be ignored if specified.
    #
    # ==== Examples
    #
    #   <%= bootstrap_alert_tag(:info, 'Check it out!!') %>
    #   # => <div class="alert alert-info"><a href="#" class="btn-close"
    #   data-bs-dismiss="alert"></a>Check it out!!</div>
    #
    # You can use a block as well if your alert message is hard to fit into the message parameter.
    # ERb example:
    #
    #   <%= bootstrap_alert_tag(:info) do %>
    #     Check it out!!
    #   <% end %>
    #   # => <div class="alert alert-info"><button type="button" class="btn-close"
    #   data-bs-dismiss="alert"></button>Check it out!!</div>
    #
    # Ids for css and/or javascript are easy to produce:
    #
    #   <%= bootstrap_alert_tag(:info, 'Check it out!!', dismissible: false, id: "news") %>
    #   # => <div class="alert alert-info" id="news">Check it out!!</div>
    #
    def bootstrap_alert_tag(*args, &block)
      type = args[0]
      if block_given?
        message = capture(&block)
        options = args[1] || {}
        bootstrap_alert_tag(type, message, options)
      else
        message = args[1] || ''
        options = args[2] || {}
        options.stringify_keys!

        classes = ['alert']
        classes << "alert-#{type}" if type && type != :alert
        unless options.include?('dismissible') && !options['dismissible']
          classes << 'alert-dismissible'
          options['dismissible'] = true
        end
        options['class'] = classes.join(' ')

        if options.delete('dismissible')
          message = button_tag('', type: 'button', class: 'btn-close', 'data-bs-dismiss': 'alert') + message
        end
        content_tag(:div, message, options)
      end
    end

    # Creates an bootstrap label of the given +type+. It supports the following types
    # <tt>:default</tt>, <tt>:success</tt>, <tt>:warning</tt>, <tt>:danger</tt>,
    # <tt>:info</tt> and <tt>:primary</tt>.
    #
    # ==== Signatures
    #
    #   bootstrap_label_tag(type, message)
    #
    # ==== Examples
    #
    #   <%= bootstrap_label_tag(:info, 'Check it out!!') %>
    #   # => <span class="label label-info">Check it out!!</span>
    #
    def bootstrap_label_tag(type, message)
      style = TYPE_STYLE_MAP[type] || type
      content_tag(:span, message, class: "badge text-bg-#{style}")
    end

    # Creates an bootstrap badge of the given +type+. Bootstrap 3 does not support any types.
    #
    # ==== Signatures
    #
    #   bootstrap_badge_tag(type, count)
    #
    # ==== Examples
    #
    #   <%= bootstrap_badge_tag(:success, 'Check it out!!') %>
    #   # => <span class="badge rounded-pill text-bg-success">Check it out!!</span>
    #
    def bootstrap_badge_tag(type, count)
      style = TYPE_STYLE_MAP[type] || type
      content_tag(:span, count, class: "badge rounded-pill text-bg-#{style}")
    end

    # Creates a simple bootstrap navigation caret.
    #
    # ==== Signatures
    #
    #   bootstrap_caret_tag
    #
    # ==== Examples
    #
    #   <%= bootstrap_caret_tag %>
    #   # => <b class="caret"></b>
    def bootstrap_caret_tag
      content_tag(:b, '', class: 'caret')
    end

    # Creates a simple bootstrap navigation dropdown.
    #
    # ==== Signatures
    #
    #   bootstrap_dropdown_toggle_tag(body)
    #
    # ==== Examples
    #
    #   <%= bootstrap_dropdown_toggle_tag('Check it out!!') %>
    #   # => <a href="#" role="button" class="nav-link dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
    #   Check it out!! <b class="caret"></b></a>
    def bootstrap_dropdown_toggle_tag(body)
      link_to(ERB::Util.html_escape(body) + ' '.html_safe + bootstrap_caret_tag,
              '#',
              role: 'button',
              class: 'nav-link dropdown-toggle',
              'data-bs-toggle': 'dropdown',
              'aria-expanded': 'false')
    end

    # Creates a simple bootstrap icon.
    #
    # ==== Signatures
    #
    #   bootstrap_icon_tag(type)
    #
    # ==== Examples
    #
    #   <%= bootstrap_icon_tag(:search) %>
    #   # => <span class="glyphicon glyphicon-search"></span>
    def bootstrap_icon_tag(type)
      content_tag(:span, '', class: "glyphicon glyphicon-#{type}")
    end

    # Creates a simple bootstrap icon spinner.
    #
    # ==== Signatures
    #
    #   bootstrap_icon_spinner(type)
    #
    # ==== Examples
    # <%= bootstrap_icon_spinner(:danger) %>
    # => <img style="width:12px;padding-bottom:2px;" src="/assets/indicator-danger.gif">
    def bootstrap_icon_spinner(type = :default)
      spinner = case type
                when :danger
                  'indicator-danger.gif'
                else
                  'indicator-white.gif'
                end

      image_tag(spinner, style: 'width:12px;padding-bottom:2px;', alt: spinner)
    end

    # Creates a simple bootstrap tab navigation.
    #
    # ==== Signatures
    #
    #   bootstrap_tab_nav_tag(title, linkto, active = false)
    #
    # ==== Examples
    #
    #   <%= bootstrap_tab_nav_tag("Fruits", "#fruits", true) %>
    #   # => <li class="active"><a href="#fruits" data-bs-toggle="tab">Fruits</a></li>
    def bootstrap_tab_nav_tag(title, linkto, active = false)
      content_tag('li',
                  link_to(title, linkto, 'data-bs-toggle': 'tab'),
                  active ? { class: 'active' } : {})
    end

    # Convenience wrapper for a bootstrap_list_link_to with badge
    def bootstrap_list_badge_and_link_to(type, count, name, path)
      html = content_tag(:div, bootstrap_badge_tag(type, count), class: 'float-end') + name
      bootstrap_list_link_to(html, path)
    end

    # TODO: list_group_link_to(*args, &block)

    # Creates a Boostrap abbreviation tag (note: the acronym tag is not valid HTML5).
    # Also adds the "initialism" class if the abbreviation is all upper case.
    #
    # ==== Signatures
    #
    #   bootstrap_abbreviation_tag(name, abbreviation)
    #
    # ==== Examples
    #
    #   <%= bootstrap_abbreviation_tag('NPI', 'Nottingham Prognostic Index') %>
    #   # => <abbr class="initialism" title="Nottingham Prognostic Index">NPI</abbr>
    def bootstrap_abbreviation_tag(name, abbreviation)
      content_tag(:abbr,
                  name,
                  title: abbreviation,
                  class: (name == name.upcase ? 'initialism' : nil))
    end

    # Identical signature to form_for, but uses NdrUi::BootstrapBuilder.
    # See ActionView::Helpers::FormHelper for details
    def bootstrap_form_for(record_or_name_or_array, *args, &_proc)
      options = args.extract_options!
      options[:html] ||= {}

      # :horizontal
      horizontal = options.delete(:horizontal)

      # stimuls controller, default `form_controller`
      options[:html][:'data-controller'] ||= ''
      controllers = (options[:html][:'data-controller'].split << 'form').uniq.join(' ')
      options[:html][:'data-controller'] = controllers

      # We switch autocomplete off by default
      raise 'autocomplete should be defined an html option' if options[:autocomplete]

      options[:html][:autocomplete] ||= 'off'

      form_for(record_or_name_or_array, *(args << options.merge(builder: NdrUi::BootstrapBuilder))) do |form|
        # Put the form builder into horizontal mode (if necessary)
        form.horizontal_mode = horizontal if horizontal

        # yield to the provided form block
        yield(form)
      end
    end

    # Identical signature to form_with, but uses NdrUi::BootstrapBuilder.
    # See ActionView::Helpers::FormHelper for details
    def bootstrap_form_with(**options, &block)
      options[:html] ||= {}
      options[:builder] = NdrUi::BootstrapBuilder
      horizontal = options.delete(:horizontal)

      # stimuls controller, default `form_controller`
      options[:html][:'data-controller'] ||= ''
      controllers = (options[:html][:'data-controller'].split << 'form').uniq.join(' ')
      options[:html][:'data-controller'] = controllers

      # We switch autocomplete off by default
      raise 'autocomplete should be defined an html option' if options[:autocomplete]

      options[:html][:autocomplete] ||= 'off'

      form_with(**options) do |form|
        # Put the form builder into horizontal mode (if necessary)
        form.horizontal_mode = horizontal if horizontal

        # yield to the provided form block
        block.call(form)
      end
    end

    # TODO: bootstrap_pagination_tag(*args, &block)

    # Creates a Boostrap control group for button.
    #
    # ==== Signatures
    #
    #   button_control_group(controls, options = {})
    #   button_control_group(options = {}) do
    #     # controls
    #   end
    #
    # ==== Examples
    #
    #   <%= button_control_group("Apples", class: "some_class") %>
    #   # =>
    #   <div class="form-group">
    #     <div class="col-sm-9 col-sm-offset-3">
    #       <div class="some_class">Apples</div>
    #     </div>
    #   </div>
    def button_control_group(*args, &block)
      return button_control_group(capture(&block), *args) if block_given?
      options = args.extract_options!
      options.stringify_keys!

      if options.delete('horizontal') == false
        options['class'] = ('form-group' + ' ' + options['class'].to_s).strip
        content_tag(:div, args.first, options)
      else
        bootstrap_horizontal_form_group nil, [3, 9] do
          options.blank? ? args.first : content_tag(:div, args.first, options)
        end
      end
    end

    # Creates a Boostrap progress bar.
    #
    # ==== Signatures
    #
    #   bootstrap_progressbar_tag(options)
    #
    # ==== Examples
    #
    #   <%= bootstrap_progressbar_tag(40) %>
    #   # => <div class="progress progress-striped active" title="40%"><div class="progress-bar"
    #   style="width:40%"></div></div>
    #
    #   <%= bootstrap_progressbar_tag(40), type: :danger %>
    #   # => <div class="progress progress-striped active" title="40%"><div
    #   class="progress-bar bg-danger" style="width:40%"></div></div>
    #
    # ==== Browser compatibility
    #
    # Bootstrap Progress bars use CSS3 gradients, transitions, and animations to achieve all their
    # effects. These features are not supported in IE7-9 or older versions of Firefox.
    # Versions earlier than Internet Explorer 10 and Opera 12 do not support animations.
    def bootstrap_progressbar_tag(*args)
      percentage = args[0].to_i
      options = args[1] || {}
      options.stringify_keys!
      options['title'] ||= "#{percentage}%"

      classes = ['progress']
      classes << options.delete('class')
      classes << 'progress-striped'

      type = options.delete('type').to_s
      type = " bg-#{type}" if type.present?

      # Animate the progress bar unless something has broken:
      classes << 'active' unless type == 'danger'

      inner = content_tag(:div, '', class: "progress-bar#{type}", style: "width:#{percentage}%")

      options['class'] = classes.compact.join(' ')
      content_tag(:div, inner, options)
    end

    # TODO: bootstrap_form_div_start_tag
    # TODO: bootstrap_form_div_end_tag

    # Supply optional label. Use options[:ratio] for grid split/offset.
    # The default is [2, 10], where 2 is label columns / offset, and
    # 10 is content width. If the label is omitted, the content is
    # offset by the same number of columns instead.
    #
    # ==== Examples
    #   bootstrap_horizontal_form_group("The Label", [3, 9]) { 'This is the content' }
    #   # =>
    #     <div class="form-group">
    #       <label class="col-sm-3 col-form-label">The Label</label>
    #       <div class="col-sm-9">This is the content</div>
    #     </div>
    #
    def bootstrap_horizontal_form_group(label = nil, ratio = [2, 10], &block)
      l, r   = ratio[0..1].map(&:to_i)
      offset = label.nil? ? " col-sm-offset-#{l}" : ''

      # Main content:
      content = content_tag(:div, class: "col-sm-#{r}" + offset, &block)
      # Prepend optional label:
      content = content_tag(:label, label, class: "col-sm-#{l} col-form-label") + content unless label.nil?

      content_tag(:div, content, class: 'form-group')
    end

    # This helper produces a pair of HTML dt, dd tags to display name and value pairs.
    # If a blank_value_placeholder is not defined then the pair are not shown if the
    # value is blank. Otherwise the placeholder is shown in the text-muted style.
    #
    # ==== Signature
    #
    #   description_list_name_value_pair(name, value, blank_value_placeholder = nil)
    #
    # ==== Examples
    #
    #   <%= description_list_name_value_pair("Pear", "Value") %>
    #   # => <dt>Pear</dt><dd>Value</dd>
    #
    #   <%= description_list_name_value_pair("Pear", nil, "[none]") %>
    #   # => <dt>Pear</dt><dd><span class="text-muted">[none]</span></dd>
    #
    def description_list_name_value_pair(name, value, blank_value_placeholder = nil)
      # SECURE: TPG 2013-08-07: The output is sanitised by content_tag
      return unless value.present? || blank_value_placeholder.present?
      content_tag(:dt, name) +
        content_tag(:dd, value || content_tag(:span, blank_value_placeholder, class: 'text-muted'))
    end

    # Creates a Boostrap button toolbar.
    #
    # ==== Signatures
    #
    #   button_toolbar(&block)
    #
    # ==== Examples
    #
    #   <%= button_toolbar { link_to('Hello World', '#') } %>
    #   # => <div class="btn-toolbar"><a href="#">Hello World</a></div>
    #
    def button_toolbar(&block)
      content_tag(:div, capture(&block), class: 'btn-toolbar')
    end

    # Creates a Boostrap button group.
    #
    # ==== Signatures
    #
    #   button_group(&block)
    #
    # ==== Examples
    #
    #   <%= button_group { link_to('Hello World', '#') } %>
    #   # => <div class="btn-group"><a href="#">Hello World</a></div>
    #
    def button_group(&block)
      content_tag(:div, capture(&block), class: 'btn-group')
    end

    # Creates a Boostrap 'New' link.
    #
    # ==== Signatures
    #
    #   new_link(path, options = {})
    #
    # ==== Examples
    #
    #   <%= new_link('#') %>
    #   # => <a title="New" class="btn btn-primary btn-sm" href="#">
    #          <span class="glyphicon glyphicon-plus-sign"></span>
    #        </a>
    #
    #   <%= new_link(Post.new) %>
    #   # => <a title="New" class="btn btn-primary btn-sm" href="/posts/new">
    #          <span class="glyphicon glyphicon-plus-sign"></span>
    #        </a>
    #
    def new_link(path, options = {})
      return unless options.delete(:skip_authorization) || ndr_can?(:new, path)

      path = new_polymorphic_path(path) if can_generate_polymorphic_path?(path)

      defaults = {
        icon: 'plus-sign', title: 'New', path: path, class: 'btn btn-primary btn-sm'
      }

      link_to_with_icon(defaults.merge(options))
    end

    # Creates a Boostrap 'Details' link.
    #
    # ==== Signatures
    #
    #   details_link(path, options = {})
    #
    # ==== Examples
    #
    #   <%= details_link('#') %>
    #   # => <a title="Details" class="btn btn-default btn-sm" href="#">
    #          <span class="glyphicon glyphicon-share-alt"></span>
    #        </a>
    #
    def details_link(path, options = {})
      return unless options.delete(:skip_authorization) || ndr_can?(:read, path)

      link_to_with_icon({ icon: 'share-alt', title: 'Details', path: path }.merge(options))
    end

    # Creates a Boostrap 'Edit' link.
    #
    # ==== Signatures
    #
    #   edit_link(path, options = {})
    #
    # ==== Examples
    #
    #   <%= edit_link(#) %>
    #   # => <a title="Edit" class="btn btn-default btn-sm" href="#">
    #          <span class="glyphicon glyphicon-pencil"></span>
    #        </a>
    #
    def edit_link(path, options = {})
      return unless options.delete(:skip_authorization) || ndr_can?(:edit, path)

      path = edit_polymorphic_path(path) if path.is_a?(ActiveRecord::Base)

      link_to_with_icon({ icon: 'pencil', title: 'Edit', path: path }.merge(options))
    end

    # Creates a Boostrap 'Delete' link.
    #
    # ==== Signatures
    #
    #   delete_link(path, options = {})
    #
    # ==== Examples
    #
    #   <%= delete_link('#') %>
    #   # => <a title="Delete" class="btn btn-sm btn-outline-danger" rel="nofollow" href="#"
    #           data-method="delete" data-confirm="Are you sure?">
    #          <span class="glyphicon glyphicon-trash icon-white"></span>
    #        </a>'
    def delete_link(path, options = {})
      return unless options.delete(:skip_authorization) || ndr_can?(:delete, path)

      defaults = {
        icon: 'trash icon-white', title: 'Delete', path: path,
        class: 'btn btn-sm btn-outline-danger', method: :delete,
        'data-confirm': I18n.t(:'ndr_ui.confirm_delete', locale: options[:locale])
      }

      link_to_with_icon(defaults.merge(options))
    end

    # Creates a Boostrap inline menu, with show/edit/delete links.
    # If possibly, conditionally checks permissions
    #
    # ==== Signatures
    #
    #   inline_controls_for(object, options = {})
    #
    # ==== Examples
    #
    #   # creates: [ [delete] ] [ [edit] [details] ]
    #   <%= inline_controls_for(@post) %>
    #
    def inline_controls_for(object, options = {})
      groups = []

      groups << delete_link(object)

      main_group = [edit_link(object, options), details_link(object, options)]
      groups << safe_join(main_group) if main_group.any?

      groups.compact!
      groups.map! { |group| button_group { group } }

      button_toolbar { safe_join(groups) } if groups.any?
    end

    # Creates a Boostrap link with icon.
    #
    # ==== Signatures
    #
    #   link_to_with_icon(options)
    #
    # ==== Examples
    #
    #   <%= link_to_with_icon( { icon: 'trash icon-white', title: 'Delete', path: '#' } ) %>
    #   # => <a title="Delete" class="btn btn-default btn-sm" href="#">
    #          <span class="glyphicon glyphicon-trash icon-white"></span>
    #        </a>'
    def link_to_with_icon(options = {})
      options[:class] ||= 'btn btn-default btn-sm'
      icon = bootstrap_icon_tag(options.delete(:icon))
      content = options.delete(:text) ? "#{icon} #{options[:title]}" : icon
      link_to content, options.delete(:path), options
    end

    # TODO: bootstrap_will_paginate(collection = nil, options = {})

    private

    # If an authorisation provider (i.e. CanCan) exists, use it:
    def ndr_can?(action, subject, *extra_args)
      return true unless respond_to?(:can?)

      unless subject.is_a?(ActiveRecord::Base)
        deprecator = if Rails.application.respond_to?(:deprecators)
                       Rails.application.deprecators[:active_support]
                     else
                       ActiveSupport::Deprecation # Rails <= 7.0
                     end
        deprecator.warn(<<~MSG)
          Attempting to authorise a non-resource object causes authorisation to be skipped.
          In future, this behaviour may change; please use a resource where possible.
        MSG

        return true
      end

      can?(action, subject, *extra_args)
    end

    def can_generate_polymorphic_path?(path)
      case path
      when Array, ActiveRecord::Base then true
      else false
      end
    end
  end
end
