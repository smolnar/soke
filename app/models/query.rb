class Query < ActiveRecord::Base
  validates :value, presence: true

  has_many :searches
  has_many :sessions, -> { uniq }, through: :searches
  has_many :results , -> { uniq }, through: :searches
  has_many :pages,    -> { uniq }, through: :results
end
