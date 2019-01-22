class Level < ApplicationRecord
  has_many :movies
  scope :key_value_pairs, ->{pluck :name, :id}
end
