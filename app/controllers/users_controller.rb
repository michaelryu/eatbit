class UsersController < ApplicationController
  before_filter :authenticate_admin_user!,
                except: [:show, :subscribe, :unsubscribe]
  skip_before_filter :verify_authenticity_token

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def subscribe
    @user = User.find(params[:id])

    token = params[:reservation][:stripe_token]

    customer = Stripe::Customer.create(
      source: token,
      plan: 'basic-calorie-plan'
    )

    @user.update_attributes(stripe_id: customer.id, subscribed: true)
    message(@user.phone, "Welcome! You can now start logging what you eat by sending in images, UPC codes, a text description or a calorie count.",
            '415-592-6475')
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
