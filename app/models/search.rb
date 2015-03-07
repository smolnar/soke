class Search < ActiveRecord::Base
  belongs_to :query
  belongs_to :session
  belongs_to :user

  has_many :results
  has_many :pages, -> { uniq }, through: :results
end
