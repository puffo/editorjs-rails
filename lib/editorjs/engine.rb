# frozen_string_literal: true

module Editorjs
  class Engine < Rails::Engine
    isolate_namespace Editorjs
    config.eager_load_namespaces << Editorjs

    config.autoload_once_paths = %W(
      #{root}/app/helpers
      #{root}/app/models
    )

    initializer "editorjs-rails.attribute" do
      ActiveSupport.on_load(:active_record) do
        include Editorjs::Attribute
      end
    end

    initializer "editorjs-rails.importmap", before: "importmap" do |app|
      if Rails.application.respond_to?(:importmap)
        app.config.importmap.paths << Engine.root.join("config/importmap.rb")
        app.config.importmap.cache_sweepers << Engine.root.join("app/javascript")
      end
    end

    initializer "editorjs-rails.assets" do |app|
      if Rails.application.config.respond_to?(:assets)
        app.config.assets.paths << Engine.root.join("app/javascript")
      end
    end

    initializer "editorjs-rails.helper" do
      %i[action_controller_base action_mailer].each do |abstract_controller|
        ActiveSupport.on_load(abstract_controller) do
          helper Editorjs::Engine.helpers
        end
      end
    end
  end
end
