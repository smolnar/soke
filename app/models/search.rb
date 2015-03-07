class Search < ActiveRecord::Base
  belongs_to :query
  belongs_to :session
end
