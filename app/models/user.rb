class User < ActiveRecord::Base
  has_many :texts
  has_many :entries
  default_scope { order(updated_at: :desc) }

end
