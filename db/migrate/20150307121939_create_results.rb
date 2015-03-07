class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.references :search, null: false
      t.references :page,   null: false

      t.integer  :position,   null: false
      t.boolean  :clicked,    null: false, default: false
      t.datetime :clicked_at

      t.timestamps
    end

    add_index :results, [:search_id, :page_id], unique: true
  end
end