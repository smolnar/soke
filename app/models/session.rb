class Session < ActiveRecord::Base
  belongs_to :user

  has_many :searches
  has_many :queries, through: :searches
end
