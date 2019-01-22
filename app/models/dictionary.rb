class Dictionary < ApplicationRecord
  validates :word_en, :word_vi, :pronounciation, presence: true
end
