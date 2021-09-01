class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :name, presence: true
  # メールアドレスの正規表現を定義。絶対にメールアドレスではない形式で入力されたものを排除
  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  # case_sensitive: falseで大文字小文字の区別をしない。(sample@example.comとSample@example.comは同じとみなす)
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  # passwordとpassword_confirmationはuserモデルのカラムには存在しない。crypted_passwordカラムの仮想属性であるとここで示す。
  validates :password, length: { minimum: 4 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
end