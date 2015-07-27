class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @text = Text.new
  end

  def today
    @calories = 0
    User.all.each do |user|
      user.entries.where('created_at::date = ?', Date.today).each do |entry|
        @calories += entry.calorie.to_i
      end
      puts @calories
    end
  end
end
