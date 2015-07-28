class UsersController < ApplicationController
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
    redirect_to root_path
  end

  def texts
    @user = User.find(params[:id])
    @text = Text.new
  end
end
