class OutfitImageUploader < ApplicationUploader
  # ストレージの種類
  # storage :file
  # storage :fog

  if Rails.env.production?
    # 本番環境はS3に保存
    storage :fog 
  else
    # それ以外はpublicへ保存
    storage :file
  end


  # アップロードされた画像データはpublic/uploaders/配下に置かれる。
  # 以下の設定であれば、public/uploaders/単数テーブル名/画像カラム名/インスタンスのid番号
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # app/assets/imagesの中から拾ってくる
  def default_url
    'default_outfit.jpg'
  end

  def filename
    "#{model.id}.jpg"
  end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add an allowlist of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_allowlist
    %w(jpg jpeg gif png)
  end

  
end
