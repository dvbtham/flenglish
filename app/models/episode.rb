class Episode < ApplicationRecord
  belongs_to :movie
  has_many :subtitles

  validates :name, :video_url, :movie_id, presence: true
end
