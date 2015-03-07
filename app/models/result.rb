class Result < ActiveRecord::Base
  belongs_to :search
  belongs_to :page
end
