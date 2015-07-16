class TextsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :force_ssl

  def create
    @text = Text.create(text_params)
    client = Twilio::REST::Client.new(Rails.application.secrets.twilio_account_sid,
                                      Rails.application.secrets.twilio_auth_token)
    message = client.messages.create(from: '+1 (415) 592-6475',
                                     to: @text.phone, body: @text.content)
  end

  def entry
    user
    @text = Text.create(phone: params['From'], user_id: @user.id,
                        content: params['Body'], picture: params['MediaUrl0'])
  end

  def user
    @user = User.find_by(phone: params['From'])
    return if @user
    @user = User.create
    @user.update_attribute('phone', params['From'])
  end
  
  private

  def text_params
    params.require(:text).permit(:phone, :content, :user_id)
  end
end
