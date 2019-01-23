class RatingMovie < ApplicationRecord
  belongs_to :user
  belongs_to :movie
  validates :user_id, :movie_id, :rate, presence: true
end
