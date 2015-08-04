task daily_summary: :environment do
  User.all.each do |user|
    @calories = 0
    user.entries.where('created_at::date = ?', Date.today - 1).each do |entry|
      @calories += entry.calorie.to_i
    end
    next if @calories == 0
    client = Twilio::REST::Client.new(Rails.application.secrets.twilio_account_sid,
                                      Rails.application.secrets.twilio_auth_token)
    message = client.messages.create(from: '415-592-6475',
                                     to: user.phone, body: "Your calorie count yesterday was: #{@calories}")
  end
end
