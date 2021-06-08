class Notification < ApplicationRecord
  include Noticed::Model
  belongs_to :recipient, polymorphic: true

  after_create :recipient_notifications_checked_to_false

  after_create_commit {
    if type == 'MessageNotification'
      # channel list item (remove and then prepend)
      broadcast_replace_to(recipient, params[:message].channel, :channel_list_item, target: "channel_list_item_#{params[:message].channel.id}", partial: "components/lists/channel_list_item", locals: { channel: params[:message].channel, unread_messages: true })
      # navbar channels button
      broadcast_replace_to(recipient, :channels_button, target: "channels_button", partial: "shared/navbar/channels_button", locals: { badge: true })
    else
      # navbar notifications button update
      broadcast_replace_to(recipient, :notifications_button, target: "notifications_button", partial: "shared/navbar/notifications_button", locals: { badge: true })
      # notification elem (notifications tab)
      broadcast_prepend_to 'notifications'
    end
  }

  private

  def recipient_notifications_checked_to_false
    recipient.update(notifications_checked: false) unless type == 'MessageNotification'
  end
end
