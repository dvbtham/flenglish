class User < ApplicationRecord
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :suggests
  has_and_belongs_to_many :subtitles
  # many to many relationship to favorites table
  has_and_belongs_to_many :movies
  has_many :movie_followings, dependent: :destroy
  has_many :movies, through: :movie_followings
  has_many :rating_movies, dependent: :destroy
  has_many :movies, through: :rating_movies
  has_many :comments, dependent: :destroy
  # many to many relationship to user_movies table
  has_many :user_movies, dependent: :destroy
  has_many :movies, through: :user_movies
end
