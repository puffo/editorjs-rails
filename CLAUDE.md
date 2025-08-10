# CLAUDE.md - editorjs-rails

## Purpose
This is a Rails engine gem that provides seamless integration of Editor.js (a block-styled editor) into Rails applications. It handles content storage, rendering, and provides Rails-friendly helpers for forms and views.

## Project Structure Overview
- **app/**: Rails engine components (models, controllers, helpers, assets)
- **lib/**: Core engine configuration and attribute handling
- **db/**: Database migrations for storing Editor.js content
- **config/**: Rails routes configuration

## Key Components
- **editorjs-rails.gemspec**: Gem specification with Rails 8.0.2+ dependency
- **Gemfile**: Development dependencies
- **package.json**: JavaScript dependencies for Editor.js plugins
- **rollup.config.js**: JavaScript bundler configuration

## Important Patterns
- **Rails Engine Pattern**: Mounted as an isolated engine at `/editorjs`
- **Block-based Content**: Each Editor.js block type has a corresponding Ruby class
- **Polymorphic Association**: Text content is stored with polymorphic associations
- **HTML Rendering**: Block classes implement `to_html` method for rendering

## Dependencies
- Rails >= 8.0.2
- Addressable ~> 2.8 (URL parsing)
- Faraday ~> 2.10 (HTTP client for image uploads)
- Editor.js JavaScript libraries (via npm)

## Critical Knowledge
- **Database Required**: Run migrations before use (`rails editorjs:install:migrations`)
- **Route Mounting**: Must mount engine in routes.rb
- **JavaScript Module**: Uses ES6 modules, requires type="module" in script tag
- **Block Registration**: New block types must be registered via `Editorjs::Text::Content.register_block_type`

## Testing Approach
- Check for test directories in standard Rails locations
- Verify gem functionality through example Rails app if needed

## Recent Changes
- Updated to Rails 8.0 compatibility
- Added autoload_once_paths configuration