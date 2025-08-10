# frozen_string_literal: true

require "rails/generators"

module Editorjs
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Install Editor.js Rails integration"

      def add_javascript_import
        if File.exist?("app/javascript/application.js")
          append_to_file "app/javascript/application.js" do
            "\n// Editor.js Rails integration\nimport \"editorjs-rails\"\n"
          end
          say "✓ Added editorjs-rails import to app/javascript/application.js", :green
        else
          say "⚠ No app/javascript/application.js found. Please manually import 'editorjs-rails' in your main JavaScript file.", :yellow
        end
      end

      def install_migrations
        say "Installing migrations...", :blue
        rake "editorjs:install:migrations"
        say "✓ Migrations installed", :green
      end

      def display_post_install_message
        say "\n", :green
        say "Editor.js Rails has been installed!", :green
        say "\nNext steps:", :blue
        say "  1. Run 'rails db:migrate' to create the database tables", :yellow
        say "  2. Mount the engine in your routes.rb:", :yellow
        say "     mount Editorjs::Engine => '/editorjs'", :cyan
        say "  3. Use the editorjs_text helper in your forms:", :yellow
        say "     <%= editorjs_text :model, :content %>", :cyan
        say "\nFor more information, see the README.", :blue
      end
    end
  end
end