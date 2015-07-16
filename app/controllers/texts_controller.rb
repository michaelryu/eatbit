class TextsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :force_ssl

  def create
    # @text = [params['From'], params['Body'], params['MediaUrl0'], params['MediaUrl1'], params['MediaUrl2']]
    # TextMailer.outbound(@text).deliver_now
    # render xml: '<Response/>'
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

end
