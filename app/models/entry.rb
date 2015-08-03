class Entry < ActiveRecord::Base
  belongs_to :user, touch: true
  default_scope { order( created_at: :desc)}

end
