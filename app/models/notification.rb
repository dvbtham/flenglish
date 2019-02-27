class Notification < ApplicationRecord
  belongs_to :recipient, class_name: User.name
  belongs_to :actor, class_name: User.name
  belongs_to :notifiable, polymorphic: true

  scope :unread, ->{where read_at: nil}
end
