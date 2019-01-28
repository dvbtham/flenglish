class User < ApplicationRecord
  include Filterable

  attr_accessor :remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :suggests
  has_and_belongs_to_many :subtitles
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

  validates :email, length: {maximum: Settings.user.email.max_length},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  validates :password, length: {minimum: Settings.user.password.min_length}

  enum gender: {male: false, female: true}
  enum role: %i(member administrator)

  has_secure_password

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

  # Forgets a user.
  def forget
    update_attribute :remember_digest, nil
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  # Returns true if the given token matches the digest.
  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  class << self
    # Returns the hash digest of the given string.
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end
