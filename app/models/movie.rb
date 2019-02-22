class Movie < ApplicationRecord
  include Filterable

  belongs_to :category
  belongs_to :level
  has_many :user_favorited, dependent: :destroy, foreign_key: :movie_id,
    class_name: Favorite.name
  has_many :favoriters, through: :user_favorited, source: :user
  has_many :episodes
  has_many :movie_vocabularies, foreign_key: :movie_id,
    class_name: Vocabulary.name, dependent: :destroy
  has_many :vocabularies, through: :movie_vocabularies, source: :dictionary
  has_many :movie_followers, foreign_key: :movie_id,
    class_name: MovieFollowing.name, dependent: :destroy
  has_many :followers, through: :movie_followers, source: :user
  has_many :user_ratings, dependent: :destroy, class_name: RatingMovie.name,
    foreign_key: :movie_id
  has_many :ratings, through: :user_ratings, source: :user
  has_many :user_watchings, dependent: :destroy, class_name: UserMovie.name,
    foreign_key: :movie_id
  has_many :watchings, through: :user_watchings, source: :user
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :genres

  delegate :name, to: :category, allow_nil: true, prefix: true
  accepts_nested_attributes_for :genres, :vocabularies

  scope :newest, ->{order created_at: :desc}
  scope :features, ->{where is_feature: true}

  validates :title_en, :title_vi, :description, presence: true
  validate  :picture_size
  mount_uploader :image_url, PictureUploader

  ransack_alias :title, :title_vi_or_title_en

  def picture_size
    if image_url.size > Settings.picture_size.megabytes
      errors.add :image_url,
        t("incorrect_picture_size", max_size: Settings.picture_size)
    end
  end

  def self.filterable_columns
    {is_feature: I18n.t("sort_column.feature"),
     views: I18n.t("sort_column.views"),
     created_at: I18n.t("sort_column.newest")}.map{|key, value| [value, key]}
  end

  def genre_names
    genres.map(&:name).join ", "
  end

  def comments_with_pagination page
    comments.recent.paginate page: page, per_page: Settings.per_page.comments
  end

  def image
    return Settings.no_image unless image_url?
    image_url.url
  end

  def mail_to_user_following user
    FollowingMailer.to_users_following_movie(user, self).deliver_later
  end
end
