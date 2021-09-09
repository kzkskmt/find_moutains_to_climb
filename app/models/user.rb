class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :posts, dependent: :destroy

  enum sex: { man: 0, woman: 1, else: 2 }

  validates :name, presence: true
  # メールアドレスの正規表現を定義。絶対にメールアドレスではない形式で入力されたものを排除
  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  # case_sensitive: falseで大文字小文字の区別をしない。(sample@example.comとSample@example.comは同じとみなす)
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  # passwordとpassword_confirmationはuserモデルのカラムには存在しない。crypted_passwordカラムの仮想属性であるとここで示す。
  # 登録ユーザーがパスワード以外のプロフィール項目を更新したい場合に、パスワードの入力を省略
  validates :password, length: { minimum: 4 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  # パスワードを変更した際、reset_password_tokenがnilになるのでユニーク制約に引っかかってしまう。そこで、allow_nil：trueを加えることでnilを許可
  validates :reset_password_token, uniqueness: true, allow_nil: true

  def own?(object)
    id == object.user_id
  end
end
