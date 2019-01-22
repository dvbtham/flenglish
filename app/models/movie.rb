class Movie < ApplicationRecord
  include Filterable

  belongs_to :category
  belongs_to :level
  has_many :user_favorited, dependent: :destroy, foreign_key: :movie_id,
    class_name: Favorite.name
  has_many :favoriters, through: :user_favorited, source: :user
  has_many :episodes
  has_many :movie_vocabularies, foreign_key: :dictionary_id,
    class_name: Vocabulary.name, dependent: :destroy
  has_many :vocabularies, through: :movie_vocabularies, source: :dictionary
  has_many :movie_followers, foreign_key: :movie_id,
    class_name: MovieFollowing.name, dependent: :destroy
  has_many :followers, through: :movie_followers, source: :user
  has_many :user_ratings, dependent: :destroy, foreign_key: :movie_id
  has_many :ratings, through: :user_ratings, source: :user
  has_many :user_watchings, dependent: :destroy, foreign_key: :movie_id
  has_many :watchings, through: :user_watchings, source: :user
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :genres

  scope :newest, ->{order created_at: :desc}
  scope :column_sort, ->(column){order "? DESC", column}
  scope :level, ->(level_id){where level_id: level_id}
  scope :genre, (lambda do |genre_id|
    joins(:genres).where("genres_movies.genre_id = ?", genre_id)
  end)
  scope :category, ->(category_id){where category_id: category_id}
  scope :features, ->{where is_feature: true}
  scope :term, (lambda do |term|
    where "title_en LIKE ? OR title_vi LIKE ?", "%#{term}%", "%#{term}%"
  end)

  def self.filterable_columns
    {is_feature: I18n.t("sort_column.feature"),
     views: I18n.t("sort_column.views"),
     created_at: I18n.t("sort_column.newest")}.map{|key, value| [value, key]}
  end
end
