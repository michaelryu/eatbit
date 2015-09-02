class UsersController < ApplicationController
  before_filter :authenticate_admin_user!,
    except: [:show, :subscribe, :unsubscribe, :log]
  skip_before_filter :verify_authenticity_token

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def subscribe
    @user = User.find(params[:id])
    unless @user.subscribed
      token = params[:reservation][:stripe_token]
      customer = Stripe::Customer.create(
        source: token,
        plan: 'basic-calorie-plan',
        trial_end: 1.month.from_now.to_i,
        metadata: { 'phone' => "#{@user.phone}" }
      )

      @user.update_attributes(stripe_id: customer.id, subscribed: true)
      slack('New user has signed up')
      message(@user.phone, "Welcome! You can now start logging what you eat by sending in images, UPC codes, a text description or a calorie count.",
              '415-592-6475')
    end
    redirect_to root_path
  end

  def log
    @user = User.find(params[:id])
    @entries = @user.entries
    @logs = @entries.group_by do |entry|
      entry.created_at.strftime("%Y-%m-%d")
    end
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
