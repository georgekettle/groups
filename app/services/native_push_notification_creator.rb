class NativePushNotificationCreator < ApplicationService
  def initialize(title, body, expo_token, data = {})
    @title = title
    @body = body
    @expo_token = expo_token
    @data = data
  end

  def call
    puts "-----------------"
    p "Sending Expo Notification 🚀"
    puts "-----------------"

    client = Exponent::Push::Client.new

    message = {
      to: @expo_token,
      sound: 'default',
      title: @title,
      body: @body
    }

    handler = client.send_messages([message])

    puts "-----------------"
    p "Sending Expo Notification Sent 🚀"
    puts "-----------------"


    puts "--------Any Errors?---------"
    puts handler.errors
    puts "-----------------"
    true
  end
end
