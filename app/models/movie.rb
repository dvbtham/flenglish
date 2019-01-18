class Movie < ApplicationRecord
  belongs_to :category
  has_and_belongs_to_many :genres
  has_many :favorites
  has_many :users, through: :favorites
  has_many :episodes
  has_and_belongs_to_many :dirictionaries
  # many to many relationship to favorites table
  has_and_belongs_to_many :users
  has_many :movie_followings, dependent: :destroy
  has_many :users, through: :movie_followings
  has_many :rating_movies, dependent: :destroy
  has_many :users, through: :rating_movies
  has_many :user_movies, dependent: :destroy
  has_many :users, through: :user_movies
  has_many :comments, dependent: :destroy

  enum level: %i(beginner medium advanced)
end
