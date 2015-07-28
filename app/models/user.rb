class User < ActiveRecord::Base
  has_many :texts, dependent: :destroy
  has_many :entries, dependent: :destroy
  default_scope { order(updated_at: :desc) }

end
