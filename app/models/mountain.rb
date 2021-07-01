class Mountain < ApplicationRecord
  include JpPrefecture
  mount_uploader :image, ImageUploader
  jp_prefecture :prefecture_code, method_name: :pref

  has_many :courses
end
