class Episode < ApplicationRecord
  belongs_to :movie
  has_many :subtitles

  accepts_nested_attributes_for :subtitles, allow_destroy: true
end
