class User < ActiveRecord::Base
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable
         # TODO implement
         # :confirmable

  has_many :searches, -> { order(:created_at) }
  has_many :sessions, through: :searches
  has_many :queries,  through: :searches
end
