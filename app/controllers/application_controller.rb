class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger
  before_action :require_login #sorceryが作成するメソッド。ログインしてない時not_authenticatedメソッドを発火する

  protected

  def not_authenticated
    redirect_to login_path, danger: t('mountains.index.fail')
  end
end