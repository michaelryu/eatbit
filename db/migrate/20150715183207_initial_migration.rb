class InitialMigration < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp'
    create_table :users, id: :uuid do |t|
      t.string :phone
      t.string :owner, default: ''
      t.string :stripe_id
      t.boolean :subscribed, default: false
      t.timestamps null: false
    end
    create_table :texts do |t|
      t.string :phone
      t.text :content
      t.string :owner, default: ''
      t.uuid :user_id
      t.timestamps null: false
    end
    create_table :entries do |t|
      t.string :phone
      t.text :content
      t.string :calorie
      t.string :owner
      t.uuid :user_id
      t.string :picture
      t.timestamps null: false
    end
  end
end
