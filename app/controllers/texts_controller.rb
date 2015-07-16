class TextsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :force_ssl

  def create
    @text = Text.create(text_params)
    client = Twilio::REST::Client.new(Rails.application.secrets.twilio_account_sid,
                                      Rails.application.secrets.twilio_auth_token)
    message = client.messages.create(from: @text.owner,
                                     to: +16665554545, body: @text.content)
    redirect_to user_path(@text.user_id)
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
    @user.update_attributes(phone: params['From'], owner: params['To'])
  end
  
  private

  def text_params
    params.require(:text).permit(:phone, :content, :user_id, :owner)
  end
end
