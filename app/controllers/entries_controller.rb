class EntriesController < ApplicationController
  before_filter :authenticate_admin_user!

  def create
  end

  def edit
  end

  def index
    @entries = Entry.where(calorie: nil)
    @text = Text.new
  end

  def all
    @entries = Entry.all
    @text = Text.new
  end

  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy
    redirect_to entries_path
  end

  def update
    @entry = Entry.find(params[:id])
    @entry.update(entry_params)
  end

  def add_calories
  end

  private

  def entry_params
    params.require(:entry).permit(:phone, :content, :user_id, :owner, :calorie)
  end
end
