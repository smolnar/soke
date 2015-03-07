class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.string :title,       null: false
      t.string :url,         null: false
      t.text   :description, null: false
      t.string :bing_uuid,   null: false

      t.timestamps
    end

    add_index :results, :bing_uuid
  end
end
