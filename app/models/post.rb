class Post < ApplicationRecord
  belongs_to :user
  belongs_to :mountain

  validates :title, presence: true, length: { maximum: 20 }
  validates :body, presence: true, length: { maximum: 1_000 }
end
