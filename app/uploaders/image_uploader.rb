class ImageUploader < ApplicationUploader
  # ストレージの種類
  # storage :file
  # storage :fog

  if Rails.env.production?
    storage :fog # 本番環境のみS3
  else
    storage :file # 本番環境以外はpublic
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

  def default_url
    'mountain_default.png'
  end

  # オリジナル画像のサイズ指定と、詳細ページ用のmain_imageを保存する。
  # resize_to_fillは切り取りメソッド、第3引数は切り取りの中心点
  # resize_to_fitは拡大縮小メソッド、縦横は維持されつつ、指定したサイズ内で最大になるようにリサイズ。
  process resize_to_fit: [820, nil]

  def filename
    "#{model.id}_#{model.name_en}.jpg"
  end

  # アップロードする画像の許容する拡張子を設定
  def extension_allowlist
    %w[jpg jpeg gif png]
  end
end
