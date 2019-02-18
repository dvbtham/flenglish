class Subtitle < ApplicationRecord
  belongs_to :episode
  has_and_belongs_to_many :users

  scope :load_subtitles, ->(episode_id){where episode_id: episode_id}
end
