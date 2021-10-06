class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  # パスワードリセット申請フォーム用のアクション
  def new; end

  # パスワードリセットをリクエストするアクション
  # ユーザーがパスワードリセット申請フォームにemailを入力し、送信したときにこのアクションが実行される
  def create
    # フォームで入力されたemailからuserを探す
    @user = User.find_by(email: params[:email])
    # DB上に該当ユーザが見つかれば、パスワードリセット案内メールをuserに送信（ランダムトークン付きのURL/有効期限付き）
    # deliver_reset_password_instructionsでapp/mailers/user_mailer.rbのreset_password_emailメソッドが実行される。
    @user&.deliver_reset_password_instructions!

    # なお、userの存在の有無に関わらず、リダイレクトして成功メッセージを表示させる。
    # これはセキュリティ対策の処理で、DB内にそのemailが存在するかどうかを第三者が確認されるのを防ぐため。
    redirect_to login_path, success: t('.success')
  end

  # パスワードリセットフォームページへ遷移するアクション
  def edit
    # メールに記載されたurlから@tokenを取り出す
    @token = params[:id]
    # 送信されてきたトークンを使って、ユーザーの検索を行い, 有効期限のチェックも行う。
    # トークンが見つかり、有効であればそのユーザーオブジェクトを@userに格納する.
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
      redirect_to login_path, success: t('.success')
    else
      flash.now[:danger] = t '.fail'
      render :edit
    end
  end
end
