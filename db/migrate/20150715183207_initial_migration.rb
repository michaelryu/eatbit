class InitialMigration < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :phone
      t.string :owner, default: ""
      t.timestamps null: false
    end
    create_table :texts do |t|
      t.string :phone
      t.text :content
      t.string :owner, default: ""
      t.integer :user_id
      t.timestamps null: false
    end
    create_table :entries do |t|
      t.string :phone
      t.text :content
      t.string :calorie
      t.string :owner
      t.integer :user_id
      t.string :picture
      t.timestamps null: false
    end
  end
end
