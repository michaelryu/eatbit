task daily_summary: :environment do
  User.all.each do |user|
    @calories = 0
    user.entries.where('created_at BETWEEN ? AND ?', DateTime.now - 32.hours, DateTime.now - 8.hours).each do |entry|
      @calories += entry.calorie.to_i
    end
    if @calories == 0
      body = "Whoops looks like we didn't record anything for you yesterday. Don’t forget to text us your food today."
    else
      body = "Your calorie count yesterday was: #{@calories}"
    end
    client = Twilio::REST::Client.new(Rails.application.secrets.twilio_account_sid,
                                      Rails.application.secrets.twilio_auth_token)
    message = client.messages.create(from: '415-592-6475',
                                     to: user.phone, body: body)
  end
end