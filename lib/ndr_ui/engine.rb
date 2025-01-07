require 'bootstrap/engine'
require 'jquery-rails'
require 'sprockets/railtie'
require 'popper_js'

module NdrUi
  # This is where we define the base class for the engine
  class Engine < ::Rails::Engine
    isolate_namespace NdrUi

    # Hook into host app's asset pipeline, allowing all the gem's assets
    # to be complied alongside. This allows the gem's assets to be referenced
    # directly by templates without issue, rather than needing to go via
    # an asset manifest in the host.
    initializer 'ndr_ui.assets.precompile' do |app|
      app.config.assets.precompile += %w[*.scss *.js *.gif *.svg]
    end

    # We configure the generator of the host app
    config.app_generators do |g|
      # Prepend our scaffold template path to the template load paths
      g.templates.unshift File.expand_path('../../templates', __FILE__)
      # Disable the generation of controller specific assets and helper
      g.assets false
      g.helper false
    end

    # We remove the fieldWithErrors div tag that Rails wraps around form elements.
    # It is not used by NdrUi::BootstrapBuilder.
    config.action_view.field_error_proc = proc { |html, _instance| html }
  end
end
