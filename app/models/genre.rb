class Genre < ApplicationRecord
  has_many :movies
  has_and_belongs_to_many :movies

  scope :key_value_pairs, ->{pluck :name, :id}
end
