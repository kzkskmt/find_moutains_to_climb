class ApplicationMailer < ActionMailer::Base
  # メールの差し出し元
  default from: 'admin@example.com'
  layout 'mailer'
end
