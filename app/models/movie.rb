class Movie < ApplicationRecord
  include Filterable
  belongs_to :category
  belongs_to :level
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
