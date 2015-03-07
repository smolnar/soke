class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.string :value, null: false

      t.timestamps
    end

    add_index :queries, :value, unique: true
  end
end
