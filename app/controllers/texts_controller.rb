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
    slack("New entry posted: #{params['Body']} #{params['MediaUrl0']}")
    return unless params['MediaUrl0']
    upc
  end

  def upc
    link = open(params['MediaUrl0'], allow_redirections: :all).base_uri.to_s
    if Rails.env.development?
      data = `zbarimg -q #{link}`.partition(':').last.to_s.strip!
    else
      data = `./.apt/usr/bin/zbarimg -q #{link}`.partition(':').last.to_s.strip!
    end
    return if data.nil?
    require 'factual'
    factual = Factual.new(ENV['FACTUAL_KEY'],
                          ENV['FACTUAL_SECRET'])
    product = factual.table('products-cpg-nutrition').search(data).rows
    if !product.blank?
      @entry.update_attribute(:calorie, product[0]['calories'].to_s)
      slack("Entry assigned calories from: https://www.factual.com/#{product[0]['factual_id']}")
    else
      api = "http://world.openfoodfacts.org/api/v0/produit/#{data}.json"
      uri = URI.parse(URI.encode(api))
      product = JSON.load(open(uri))
      if product['status'] == 1
        @entry.update_attribute(:calorie,
                                product['product']['nutriments']['energy'])
        slack("Entry assigned calories from: http://world.openfoodfacts.org/product/#{data}")
      else
        message(@user.phone, 'We could not find this product! Could you give us a short description of it?', '415-769-3888', link)
        slack("Couldn't find UPC code: #{data}")
      end
    end
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
      message(@user.phone, "We've saved your food item, but you need to signup to get the summaries. http://x.eatbit.co/users/#{@user.id}",
              '415-592-6475')
    else
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
