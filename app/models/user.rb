class User < ApplicationRecord
  include Filterable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :async, :registerable, :confirmable,
    :recoverable, :rememberable, :validatable

  # Enum, Constants
  enum gender: {male: 0, female: 1}
  enum role: {member: 0, administrator: 1}

  attr_accessor :remember_token

  # Relationships
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :suggests
  has_many :favorited_movies, foreign_key: :user_id, class_name: Favorite.name,
    dependent: :destroy
  has_many :favoriting, through: :favorited_movies, source: :movie
  has_many :movie_followings, foreign_key: :user_id,
    class_name: MovieFollowing.name, dependent: :destroy
  has_many :followed_movies, through: :movie_followings, source: :movie
  has_many :rating_movies, dependent: :destroy, foreign_key: :user_id
  has_many :rated_movies, through: :rating_movies, source: :movie
  has_many :comments, dependent: :destroy
  has_many :user_movies, dependent: :destroy, foreign_key: :user_id
  has_many :watched_movies, through: :user_movies, source: :movie
  has_many :movie_vocabularies, foreign_key: :user_id,
    class_name: UserVocabulary.name, dependent: :destroy
  has_many :vocabularies, through: :movie_vocabularies, source: :dictionary
  has_many :notifications, foreign_key: :recipient_id

  # Validations
  validates :full_name, :date_of_birth, :gender, presence: true
  validates :full_name, length: {maximum: Settings.user.name.max_length}

  # Scopes
  scope :role, ->(role_id){where role: role_id}
  scope :gender, ->(gender_id){where gender: gender_id}
  scope :term, (lambda do |term|
    where "email LIKE ? OR full_name LIKE ?", "%#{term}%", "%#{term}%"
  end)

  # Follows a user.
  def follow other_user
    following << other_user
  end

  # Unfollows a user.
  def unfollow other_user
    following.delete other_user
  end

  def saved_vocabularies movie_id
    vocabularies.where "user_vocabularies.movie_id= ?", movie_id
  end

  def find_vocabulary movie_id, dictionary_id
    movie_vocabularies.find_by movie_id: movie_id, dictionary_id: dictionary_id
  end
end
