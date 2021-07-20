class Outfit < ApplicationRecord
  mount_uploader :image, OutfitImageUploader
end
