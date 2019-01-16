class Genre < ApplicationRecord
  has_many :movies
  has_and_belongs_to_many :movies
end
