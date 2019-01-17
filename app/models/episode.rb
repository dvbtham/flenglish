class Episode < ApplicationRecord
  belongs_to :movie
  has_many :subtitles
end
