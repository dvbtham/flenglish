class ApplicationMailer < ActionMailer::Base
  default from: Settings.no_reply_mail
  layout "mailer"
end
