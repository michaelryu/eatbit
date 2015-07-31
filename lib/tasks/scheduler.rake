task daily_summary: :environment do
  @calories = 0
  User.all.each do |user|
    user.entries.where('created_at::date = ?', Date.today - 1).each do |entry|
      @calories += entry.calorie.to_i
    end
    puts @calories
    client = Twilio::REST::Client.new(Rails.application.secrets.twilio_account_sid,
                                      Rails.application.secrets.twilio_auth_token)
    message = client.messages.create(from: '415-769-3888',
                                     to: user.phone, body: "Your calorie count yesterday was: #{@calories}")
  end
end
