class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.references :query,   index: true, null: false
      t.references :session, index: true

      t.timestamps
    end
  end
end