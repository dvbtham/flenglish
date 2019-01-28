class Comment < ApplicationRecord
  belongs_to :user

  validates :content, presence: true,
    length: {maximum: Settings.comment.max_content}

  delegate :full_name, to: :user, allow_nil: true

  scope :recent, ->{order created_at: :desc}

  def owner? user
    user == self.user
  end
end
