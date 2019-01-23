class UserVocabulary < ApplicationRecord
  belongs_to :dictionary
  belongs_to :movie
  belongs_to :user
  validates :dictionary_id, :movie_id, :user_id, presence: true
end
