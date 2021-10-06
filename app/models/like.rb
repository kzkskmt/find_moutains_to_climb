class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user
  # post_idとuser_idの組が1組しか存在しないように設定
  validates :post_id, uniqueness: { scope: :user_id }
end
