class CreateEditorjsRailsTexts < ActiveRecord::Migration[7.0]
  def change
    # Determine database adapter
    adapter_type = connection.adapter_name.downcase
    use_uuid = adapter_type.include?('postgresql')

    # Create table with appropriate ID type
    create_table :editorjs_rails_texts, id: (use_uuid ? :uuid : :primary_key) do |t|
      t.string :name, null: false

      # Use jsonb for PostgreSQL, text for SQLite and others
      if use_uuid
        t.jsonb :content, default: {}
      else
        t.json :content, default: '{}'
      end

      # Polymorphic reference with appropriate type
      if use_uuid
        t.references :record, null: false, polymorphic: true, index: false, type: :uuid
      else
        t.references :record, null: false, polymorphic: true, index: false
      end

      t.timestamps
    end
  end
end
