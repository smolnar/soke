class Session < ActiveRecord::Base
  has_many :searches
  has_many :queries, -> { uniq }, through: :searches

  accepts_nested_attributes_for :searches, allow_destroy: false

  def name
    "Session ##{id}"
  end
end
