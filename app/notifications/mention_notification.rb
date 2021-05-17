# To deliver this notification:
#
# MentionNotification.with(post: @post).deliver_later(current_user)
# MentionNotification.with(post: @post).deliver(current_user)

class MentionNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

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
end
