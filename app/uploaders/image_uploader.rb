class ImageUploader < ApplicationUploader
  # ストレージの種類
  storage :file
  # storage :fog

  # アップロードされた画像データはpublic/uploaders/配下に置かれる。
  # 以下の設定であれば、public/uploaders/単数テーブル名/画像カラム名/インスタンスのid番号
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    'default_mountain.jpg'
  end

  # Create different versions of your uploaded files:
  version :thumb do
    process resize_to_fill: [600, 450, "Center"]
  end

  version :main_image do
    process resize_to_fill: [392, 293, "Center"]
  end

  # Add an allowlist of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_allowlist
    %w(jpg jpeg gif png)
  end

  
end
