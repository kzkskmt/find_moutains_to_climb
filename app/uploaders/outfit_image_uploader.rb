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

  # ファイルの保存場所の設定
  def store_dir
    # テスト環境では、アップロードされた画像データはpublic/uploaders_test/配下に置かれる。
    if Rails.env.test?
      "uploads_test/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      # アップロードされた画像データはpublic/uploaders/配下に置かれる。
      # 以下の設定であれば、public/uploaders/単数テーブル名/画像カラム名/インスタンスのid番号
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end

  # app/assets/imagesの中から拾ってくる
  def default_url
    'default_outfit.jpg'
  end

  def extension_allowlist
    %w[jpg jpeg gif png]
  end
end
