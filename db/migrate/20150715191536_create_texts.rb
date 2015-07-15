class CreateTexts < ActiveRecord::Migration
  def change
    create_table :texts do |t|
      t.string :phone
      t.text :content
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
