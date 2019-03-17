class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@exsample.com'
  layout 'user_mailer'
end
