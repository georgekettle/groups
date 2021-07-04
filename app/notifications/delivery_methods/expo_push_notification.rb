class DeliveryMethods::ExpoPushNotification < Noticed::DeliveryMethods::Base

  def deliver
    # Logic for sending the notification
    title = "#{notification.params[:message].channel.name.capitalize} channel"
    body = "#{recipient.first_name}: #{notification.params[:message].content.to_plain_text.truncate(90)}"
    expo_token = recipient.user.expo_token
    data = {}

    NativePushNotificationCreator.new(title, body, expo_token, data).call
  end

  # You may override this method to validate options for the delivery method
  # Invalid options should raise a ValidationError
  #
  # def self.validate!(options)
  #   raise ValidationError, "required_option missing" unless options[:required_option]
  # end
end
