task daily_summary: :environment do
  User.where(subscribed: true).each do |user|
    @calories = 0
    user.entries.where('created_at BETWEEN ? AND ?', DateTime.now - 32.hours, DateTime.now - 8.hours).each do |entry|
      @calories += entry.calorie.to_i
    end
    if @calories == 0
      body = "Looks like we didn't record anything for you yesterday. See more: http://x.eatbit.co/users/#{user.id}/log"
    else
      body = "Your calorie count yesterday was: #{@calories}. See more: http://x.eatbit.co/users/#{user.id}/log"
    end
    client = Twilio::REST::Client.new(Rails.application.secrets.twilio_account_sid,
                                      Rails.application.secrets.twilio_auth_token)
    message = client.messages.create(from: '415-592-6475',
                                     to: user.phone, body: body)
  end
end