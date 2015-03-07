class Search < ActiveRecord::Base
  belongs_to :query
  belongs_to :session
  belongs_to :user

  has_many :results, -> { order(:created_at) }
  has_many :pages, through: :results
end
