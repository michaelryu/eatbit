class TextMailer < ApplicationMailer
  default from: 'testcalorie@counter.com'

  def outbound(text)
    @number = text[0]
    @body = text[1]
    @pic = text[2]
    @pic2 = text[3]
    @pic3 = text[4]
    @email = ENV['email']
    mail(to: @email, subject: 'Count it!')
  end
end
