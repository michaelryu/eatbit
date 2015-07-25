class User < ActiveRecord::Base
  has_many :texts
  has_many :entries
  default_scope { order(updated_at: :desc) }

  def today(user)
    @calories = 0
    user.entries.find_each('created_at >= ?', Time.zone.now.beginning_of_day) do |entry|
      @calories += entry.calorie
    end
  end
end
