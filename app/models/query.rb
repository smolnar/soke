class Query < ActiveRecord::Base
  validates :value, presence: true

  has_many :searches, -> { order(:created_at) }
  has_many :sessions, through: :searches
  has_many :results , through: :searches
  has_many :pages,    through: :results
end
