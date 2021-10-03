source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.8'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.7'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
gem 'carrierwave'
gem 'mini_magick'
gem 'fog-aws'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'faker'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'letter_opener_web'
end

group :development do
  gem 'pry-rails'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec'
  gem 'rails_best_practices'
  gem 'better_errors'
  gem 'binding_of_caller'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara'
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Secure passwords, APIkeys
gem 'dotenv-rails'

# action_mailerの環境ごとに異なる定数を管理するためのgem
# 設定値をconfigフォルダ以下に一元管理すると、メンテナンスが楽になる
gem 'config'

# HTTPリクエストの並列処理(高速化)
gem 'typhoeus'

# Authentication
# 管理ユーザーと一般ユーザーを今後導入予定
gem 'pundit'
gem 'sorcery'

# 変数をjsでも参照できるようにする。
gem 'gon'

# その他
gem 'enum_help'
gem 'draper'
gem 'ransack'
gem 'kaminari'
gem 'nokogiri'
gem 'jp_prefecture'
gem 'Hyakumeizan'

# 内部でwheneverを使うわけではないため、Railsの実行時に読み込まないようにする
gem 'whenever', require: false

# 開発環境DBデータをseedsファイルに書き出す
gem 'seed_dump'
