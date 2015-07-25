class EntriesController < ApplicationController
  def create
  end

  def edit
  end

  def index
    @entries = Entry.all
    @text = Text.new
  end

  def destroy
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
