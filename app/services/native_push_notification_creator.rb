class NativePushNotificationCreator < ApplicationService
  def initialize(message)
    @message = message
  end

  def call
    return @message
  end
end
