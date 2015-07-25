class Entry < ActiveRecord::Base
  belongs_to :user, touch: true
  default_scope { order( updated_at: :desc)}
end
