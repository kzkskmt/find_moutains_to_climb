class Equipment < ApplicationRecord
  mount_uploader :image, OutfitImageUploader
end
