# To deliver this notification:
#
# MessageNotification.with(post: @post).deliver_later(current_user)
# MessageNotification.with(post: @post).deliver(current_user)

class MessageNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :action_cable
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"
  deliver_by :expo_push_notification, class: "DeliveryMethods::ExpoPushNotification", if: :expo_token?

  # Add required params
  #
  param :message

  # Define helper methods to make rendering easier.
  #
  # def message
  #   t(".message")
  # end
  #
  def url
    channel_path(params[:message][:channel_id], anchor: "message_#{params[:message][:id]}")
  end

  def expo_token?
    recipient.user.expo_token.present?
  end
end
