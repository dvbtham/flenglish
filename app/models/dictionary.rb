class Dictionary < ApplicationRecord
  validates :word_en, :word_vi, :pronounciation, presence: true
  scope :key_value_pairs, ->{pluck :word_en, :id}
end
