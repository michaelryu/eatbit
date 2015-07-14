# Preview all emails at http://localhost:3000/rails/mailers/text_mailer
class TextMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/text_mailer/outbound
  def outbound
    TextMailer.outbound
  end

end
