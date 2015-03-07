class User < ActiveRecord::Base
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable
         # TODO implement
         # :confirmable

  has_many :searches
  has_many :sessions, -> { uniq }, through: :searches
  has_many :queries,  -> { uniq }, through: :searches
end
