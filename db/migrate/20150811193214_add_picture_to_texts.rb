class AddPictureToTexts < ActiveRecord::Migration
  def change
    add_column :texts, :picture, :string
  end
end
