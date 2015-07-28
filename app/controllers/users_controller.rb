class UsersController < ApplicationController
  before_filter :authenticate_admin_user!, except: [:show, :subscribe, :unsubscribe]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def subscribe
    @user = User.find(params[:id])

    token = params[:stripeToken]
    email = params[:stripeEmail]

    customer = Stripe::Customer.create(
      source: token,
      plan: 'basic-calorie-plan',
      email: email
    )

    @user.update_attributes(stripe_id: customer.id, subscribed: true)
    message(@user.phone, "You are now signed up and ready to go!
      Text (415)-592-6475 your food entries and this number will be used for questions.")
    redirect_to root_path
  end

  def unsubscribe
    @user = User.find(params[:id])
    customer = Stripe::Customer.retrieve(@user.stripe_id)
    customer.subscriptions.retrieve(customer.subscriptions.first.id).delete
    @user.update_attribute('subscribed', false)
    redirect_to @user
  end

  def texts
    @user = User.find(params[:id])
    @text = Text.new
  end
end
