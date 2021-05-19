class Notification < ApplicationRecord
  include Noticed::Model
  belongs_to :recipient, polymorphic: true

  after_create :recipient_notifications_checked_to_false

  after_create_commit { broadcast_replace_to("channel_list_item_#{params[:message].channel.id}", target: "channel_list_item_#{params[:message].channel.id}", partial: "components/lists/channel_list_item", locals: { channel: params[:message].channel, unread_messages: true }) if type == 'MessageNotification' }
  after_create_commit { broadcast_replace_to(recipient, :channels_button, target: "channels_button", partial: "shared/navbar/channels_button", locals: { badge: true }) if type == 'MessageNotification' }
  after_create_commit { broadcast_prepend_to 'notifications' unless type == 'MessageNotification' }
  after_create_commit { broadcast_replace_to(recipient, :notifications_button, target: "notifications_button", partial: "shared/navbar/notifications_button", locals: { badge: true }) unless type == 'MessageNotification' }

  private

  def recipient_notifications_checked_to_false
    recipient.update(notifications_checked: false) unless type == 'MessageNotification'
  end
end
