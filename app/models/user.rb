class User < ActiveRecord::Base
	has_many :texts
	default_scope { order( updated_at: :desc)}
end
