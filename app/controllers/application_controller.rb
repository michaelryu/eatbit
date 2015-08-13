class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def message(to, body, number, *args)
    client = Twilio::REST::Client.new(Rails.application.secrets.twilio_account_sid,
                                      Rails.application.secrets.twilio_auth_token)
    message = client.messages.create(from: number,
                                     to: to, body: body, media_url: args)
  end

  def slack(message)
    webhook_url = 'https://hooks.slack.com/services/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'
    poster = Slack::Poster.new(webhook_url)
    message = 'New entry posted'
    message << ": #{params['Body']}" unless params['Body'] == ''
    poster.send_message(message)
  end
end
