class ResultsPage < ActiveRecord::Base
  belongs_to :search
  belongs_to :result
end
