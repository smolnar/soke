class AddAnnotatedAtToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :annotated_at, :datetime
  end
end
