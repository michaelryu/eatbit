class TextsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :force_ssl

  def create
    @text = Text.create(text_params)
    message(@text.phone, @text.content)
    redirect_to "/users/#{@text.user.id}/texts"
  end

  def entry
    user
    @entry = Entry.create(phone: params['From'], user_id: @user.id,
                          content: params['Body'], picture: params['MediaUrl0'])
  end

  def answer
    user
    @text = Text.create(phone: params['From'], user_id: @user.id,
                        content: params['Body'])
  end

  def user
    @user = User.find_by(phone: params['From'])
    if @user.try(:subscribed?)
      return
    elsif @user && @user.subscribed == false
      message(@user.phone, "Sign up here and get started!
      https://cf5c2507.ngrok.io/users/#{@user.id}")
    else
      @user = User.create
      @user.update_attributes(phone: params['From'], owner: params['To'])
      message(@user.phone, "Sign up here and get started!
      https://cf5c2507.ngrok.io/users/#{@user.id}")
    end
  end

  private

  def text_params
    params.require(:text).permit(:phone, :content, :user_id, :owner)
  end
end
