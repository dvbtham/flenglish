class UserMovie < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  validates :movie_id, :user_id, presence: true
end
