class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  # パスワードリセット申請フォーム用のアクション
  def new; end

  # パスワードリセットをリクエストするアクション
  # ユーザーがパスワードのリセットフォームにemailを入力し、送信したときにこのアクションが実行される
  def create
    # form_withで送られてきたemailをparamsで受け取る
    @user = User.find_by(email: params[:email])
    # DBからデータを受け取れていれば、パスワードリセットの方法を記載したメールをユーザーに送信する（ランダムトークン付きのURL/有効期限付き）
    @user.deliver_reset_password_instructions! if @user

    # フォームに入力したemailがアプリ(DB)内に存在するか否かを問わず、リダイレクトして成功メッセージを表示させる。
    # DBに存在した時だけ成功メッセージを表示させると、DB内にそのemailが存在するかどうかを悪意ある第三者でさえも確認できてしまう。
    redirect_to login_path, success: "成功しました"
  end

  # パスワードリセットフォームページへ遷移するアクション
  def edit
    # postされてきた値を取得
    @token = params[:id]
    # リクエストで送信されてきたトークンを使って、ユーザーの検索を行い, 有効期限のチェックも行う。
    # トークンが見つかり、有効であればそのユーザーオブジェクトを@userに格納する
    @user = User.load_from_reset_password_token(params[:id])
    # @userがnilまたは空の場合、not_authenticatedメソッドを実行する
    return not_authenticated if @user.blank?
  end

  # ユーザーがパスワードのリセットフォームを送信(新しいパスワードの入力)したときに実行される
  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)
    return not_authenticated if @user.blank?
    # password_confirmation属性の有効性を確認
    @user.password_confirmation = params[:user][:password_confirmation]
    # change_passwordメソッドで、パスワードリセットに使用したトークンを削除し、パスワードを更新する
    if @user.change_password(params[:user][:password])
      redirect_to login_path, success: "成功しました"
    else
      flash.now[:danger] = "失敗しました"
      render :edit
    end
  end
end
