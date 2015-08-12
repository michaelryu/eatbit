class TextsController < ApplicationController
  before_filter :authenticate_admin_user!, except: [:entry, :answer]
  skip_before_filter :verify_authenticity_token
  skip_before_filter :force_ssl

  def create
    @text = Text.create(text_params)
    unless @text.picture.blank?
      link = open(@text.picture, allow_redirections: :all).base_uri.to_s
    end
    message(@text.phone, @text.content, '415-769-3888', *link)
    redirect_to "/users/#{@text.user.id}/texts"
  end

  def entry
    user
    @entry = Entry.create(phone: params['From'], user_id: @user.id,
                          content: params['Body'], picture: params['MediaUrl0'])
    slack
    return unless params['MediaUrl0']
    upc
  end

  def slack
    webhook_url = 'https://hooks.slack.com/services/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'
    poster = Slack::Poster.new(webhook_url)
    message = 'New entry posted'
    message << ": #{params['Body']}" unless params['Body'] == ''
    poster.send_message(message)
  end

  def upc
    link = open(params['MediaUrl0'], allow_redirections: :all).base_uri.to_s
    data = `./.apt/usr/bin/zbarimg -q #{link}`.partition(':').last.to_s.strip!
    api = "http://world.openfoodfacts.org/api/v0/produit/#{data}.json"
    uri = URI.parse(URI.encode(api))
    product = JSON.load(open(uri))
    if product['status'] == 1
      @entry.update_attribute(:calorie,
                              product['product']['nutriments']['energy'])
    else
      message(@user.phone, 'We could not find this product!
        Could you give us a short description of it?', '415-769-3888', link)
    end
  end

  def answer
    user
    @text = Text.create(phone: params['From'], user_id: @user.id,
                        content: params['Body'])
  end

  def user
    @user = User.find_by(phone: params['From'])
    return if @user
    @user = User.create(phone: params['From'], owner: params['To'])
    message(@user.phone, "Welcome to Eatbit! Click to subscribe and enable your account: http://x.eatbit.co/users/#{@user.id}",
            '415-592-6475')
    message(@user.phone, 'Questions? Just ask!', '415-592-6475')
  end

  private

  def text_params
    params.require(:text).permit(:phone, :content, :user_id, :owner, :picture)
  end
end
