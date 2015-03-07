class CreateResultsPages < ActiveRecord::Migration
  def change
    create_table :results_pages do |t|
      t.references :search, null: false
      t.references :result, null: false

      t.integer  :position,   null: false
      t.boolean  :clicked,    null: false, default: false
      t.datetime :clicked_at

      t.timestamps
    end

    add_index :results_pages, [:search_id, :result_id], unique: true
  end
end
