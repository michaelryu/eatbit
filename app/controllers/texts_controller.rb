class TextsController < ApplicationController
  before_filter :authenticate_admin_user!, except: [:entry, :answer]
  skip_before_filter :verify_authenticity_token
  skip_before_filter :force_ssl

  def create
    @text = Text.create(text_params)
    message(@text.phone, @text.content, '415-769-3888')
    redirect_to "/users/#{@text.user.id}/texts"
  end

  def entry
    user
    @entry = Entry.create(phone: params['From'], user_id: @user.id,
                          content: params['Body'], picture: params['MediaUrl0'])
    # return unless params['MediaUrl0']
    # link = process_uri(params['MediaUrl0'])
    # img = MiniMagick::Image.open(link)
    # require 'zbar'
    # data = ZBar::Image.from_pgm(img.format('PGM').to_blob).process
    # code = data[0].instance_variable_get(:@data)
    # product = Openfoodfacts::Product.get(code, locale: 'world')
    # return if product.nil?
    # @entry.update_attribute(:calorie, product.nutriments.energy)
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
      message(@user.phone, "Hi, welcome to Eatbit! Click to pay and enable your account:
        https://count-calories.herokuapp.com/users/#{@user.id}", '415-592-6475')
      message(@user.phone, 'Questions? Just ask!', '415-592-6475')
    else
      @user = User.create(phone: params['From'], owner: params['To'])
      message(@user.phone, "Hi, welcome to Eatbit! Click to pay and enable your account:
        https://count-calories.herokuapp.com/users/#{@user.id}", '415-592-6475')
      message(@user.phone, 'Questions? Just ask!', '415-592-6475')
    end
  end

  private

  def text_params
    params.require(:text).permit(:phone, :content, :user_id, :owner)
  end

  def process_uri(uri)
    require 'open-uri'
    require 'open_uri_redirections'
    open(uri, allow_redirections: :all) do |r|
      r.base_uri.to_s
    end
  end
end
