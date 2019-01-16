class Subtitle < ApplicationRecord
  belongs_to :episode
  has_and_belongs_to_many :users
end
