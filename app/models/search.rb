class Search < ActiveRecord::Base
  belongs_to :query
  belongs_to :session
  belongs_to :user

  has_many :results
  has_many :pages, -> { uniq }, through: :results

  scope :annotated, -> { where.not(annotated_at: nil) }

  before_save :create_session!

  private

  def create_session!
    self.session = Session.create! unless self.session
  end
end
