class Session < ActiveRecord::Base
  has_many :searches, -> { order(:created_at) }
  has_many :queries, through: :searches
end
