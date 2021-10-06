class UserMailer < ApplicationMailer
  # コントローラの場合と同様、メイラーのメソッド内で定義されたインスタンス変数はメイラーのビューで使える。
  def reset_password_email(user)
    # reset_password_email.html.erbで呼び出される@user,@url
    @user = User.find(user.id)
    @url = edit_password_reset_url(@user.reset_password_token)
    mail(to: user.email, subject: 'パスワードリセット')
  end
end
