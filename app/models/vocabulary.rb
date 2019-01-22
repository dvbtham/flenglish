class Vocabulary < ApplicationRecord
  belongs_to :dictionary
  belongs_to :movie
  validates :dictionary_id, :movie_id, presence: true
end
