ActiveRecord::Schema.define(version: 20_150_715_183_207) do

  enable_extension 'plpgsql'

  create_table 'entries', force: :cascade do |t|
    t.string 'phone'
    t.text 'content'
    t.string 'calorie'
    t.string 'owner'
    t.integer 'user_id'
    t.string 'picture'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'texts', force: :cascade do |t|
    t.string 'phone'
    t.text 'content'
    t.string 'owner',      default: ''
    t.integer 'user_id'
    t.datetime 'created_at',              null: false
    t.datetime 'updated_at',              null: false
  end

  create_table 'users', force: :cascade do |t|
    t.string 'phone'
    t.string 'owner',      default: ''
    t.string 'stripe_id'
    t.boolean 'subscribed',  default: false
    t.datetime 'created_at',              null: false
    t.datetime 'updated_at',              null: false
  end
end
