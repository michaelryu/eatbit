class TextsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :force_ssl

  def create
    # @text = [params['From'], params['Body'], params['MediaUrl0'], params['MediaUrl1'], params['MediaUrl2']]
    # TextMailer.outbound(@text).deliver_now
    # render xml: '<Response/>'
    @user = User.find(phone: params['From'])
    rescue ActiveRecord::RecordNotFound
      @user = User.create
      @user.update_attribute('phone', params['From'])
      puts @user.phone
  end
end
