class Comment < ApplicationRecord
  belongs_to :user
  delegate :full_name, to: :user, allow_nil: true
end
