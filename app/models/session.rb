class Session < ActiveRecord::Base
  has_many :searches
  has_many :queries, -> { uniq }, through: :searches
end
