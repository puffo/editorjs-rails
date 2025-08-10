# editorjs-rails

[Editor.js](https://editorjs.io/) integration for Rails using importmaps.

Provides Rails helpers and JavaScript modules to integrate the Editor.js block-styled editor into Rails applications without requiring Node.js or a build step. Uses native ES modules and importmaps for modern, efficient JavaScript delivery.

## Requirements

- Rails 8.0.2 or higher
- importmap-rails gem (automatically included)

## Installation

Add the `editorjs-rails` gem to your `Gemfile`:

```ruby
gem "editorjs-rails", github: "puffo/editorjs-rails"
```

Run the installation generator:

```sh
bundle install
rails generate editorjs:install
```

This will:
- Add the `import "editorjs-rails"` statement to your application.js
- Install the database migrations for storing Editor.js content

Then migrate your database:

```sh
rails db:migrate
```

Mount the engine in your `config/routes.rb`:

```ruby
mount Editorjs::Engine, at: "/editorjs"
```

## Usage

Add an attribute to your model using `has_text`:

```ruby
class MyModel < ApplicationRecord
  has_text :my_awesome_text
end
```

Then use the `editorjs_text_area` form helper in your views:

```erb
<%= form_with model: @my_model do |form| %>
  <%= form.editorjs_text_area :my_awesome_text %>
<% end %>
```

Use `to_html` to render your content:

```erb
<%= @my_model.my_awesome_text.to_html %>
```

## Technical Implementation

This gem uses Rails importmaps to deliver Editor.js as ES modules directly to the browser:

- **No build step required** - JavaScript modules are served directly without bundling
- **Better caching** - Individual modules are cached separately via HTTP/2
- **CDN delivery** - Editor.js packages are loaded from esm.sh CDN for optimal performance
- **Native ES modules** - Uses modern browser capabilities for module loading

## Adding Custom Plugins

First, define `window.EditorJS.Rails.tools` following the [Editor.js convention](https://editorjs.io/configuration/):

```js
import "@editorjs/paragraph";

window.EditorJS.Rails = {
  tools: {
    paragraph: Paragraph
  }
};
```

Then register your new block type:

```ruby
class ParagraphBlock < Editorjs::Text::Block
  attr_reader :text

  def initialize(**options)
    super

    @text = @data["text"]
  end

  def to_html
    tag.p(@text.html_safe)
  end
end

Editorjs::Text::Content.register_block_type :paragraph, ParagraphBlock
```

## Included Block Tools

| Tool | Ruby Class | NPM Package | Shortcut |
|---|---|---|---|
| Header | `Editorjs::Text::Block::Header` | [`@editorjs/header`](https://github.com/editor-js/header) | `CMD+ALT+H` |
| Paragraph | `Editorjs::Text::Block::Paragraph` | Built-in | - |
| List | `Editorjs::Text::Block::List` | [`@editorjs/nested-list`](https://github.com/editor-js/nested-list) | `CMD+ALT+L` |
| Quote | `Editorjs::Text::Block::Quote` | [`@editorjs/quote`](https://github.com/editor-js/quote) | `CMD+ALT+Q` |
| Image | `Editorjs::Text::Block::Image` | [`@editorjs/image`](https://github.com/editor-js/image) | - |
| Raw HTML | `Editorjs::Text::Block::Raw` | [`@editorjs/raw`](https://github.com/editor-js/raw) | - |
| Delimiter | `Editorjs::Text::Block::Delimiter` | [`@editorjs/delimiter`](https://github.com/editor-js/delimiter) | - |

## Included Inline Tools

| Tool | NPM Package | Shortcut | Description |
|---|---|---|---|
| Bold | Built-in | `CMD+B` | Bold text |
| Italic | Built-in | `CMD+I` | Italic text |
| Link | Built-in | `CMD+K` | Add hyperlink |
| Marker | [`@editorjs/marker`](https://github.com/editor-js/marker) | `CMD+SHIFT+M` | Highlight text |
| Underline | [`@editorjs/underline`](https://github.com/editor-js/underline) | `CMD+SHIFT+U` | Underline text |
| Strikethrough | [`@sotaproject/strikethrough`](https://github.com/sotaproject/strikethrough) | `CMD+SHIFT+S` | Strike through text |
| Inline Code | [`@editorjs/inline-code`](https://github.com/editor-js/inline-code) | `CMD+SHIFT+C` | Inline code formatting |

## Keyboard Shortcuts

- **Open block menu**: Type `/` at the beginning of a line
- **Convert block**: Select text and use `TAB` to open the block conversion menu
- **Navigate blocks**: Use arrow keys to move between blocks
- **Delete block**: Press `BACKSPACE` in an empty block

## Troubleshooting

### JavaScript modules not loading

If you see 404 errors for JavaScript modules:

1. Ensure importmap-rails is installed and configured
2. Check that the engine is properly mounted in routes.rb
3. Verify that `rails generate editorjs:install` was run successfully
4. Clear your browser cache and Rails asset cache

### Editor not initializing

The editor initializes automatically on elements with the `.editorjs` class. If it's not working:

1. Check that Turbo is loaded (the editor hooks into `turbo:load` events)
2. Verify the form helper is generating the correct HTML structure
3. Check the browser console for JavaScript errors

## Development

To contribute or modify this gem:

```bash
git clone https://github.com/puffo/editorjs-rails.git
cd editorjs-rails
bundle install
```

### Adding New Block Types

1. Add the NPM package to `config/importmap.rb`
2. Import and configure it in `app/javascript/editorjs-rails.js`
3. Create a corresponding Ruby class in `app/models/editorjs/text/block/`
4. Register the block type with `Editorjs::Text::Content.register_block_type`

