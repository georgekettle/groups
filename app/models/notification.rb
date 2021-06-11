class Notification < ApplicationRecord
  include Noticed::Model
  belongs_to :recipient, polymorphic: true

  after_create :recipient_notifications_checked_to_false

  after_destroy_commit -> { broadcast_remove_to recipient }

  after_create_commit {
    if type == 'MessageNotification'
      # channel list item (remove and then prepend)
      broadcast_replace_to(recipient, target: "channel_list_item_#{params[:message].channel.id}", partial: "components/lists/channel_list_item", locals: { channel: params[:message].channel, unread_messages: true, move_to_top: true })
      # navbar channels button
      broadcast_replace_to(recipient, target: "channels_button", partial: "shared/navbar/channels_button", locals: { badge: true })
    else
      # navbar notifications button update
      broadcast_replace_to(recipient, target: "notifications_button", partial: "shared/navbar/notifications_button", locals: { badge: true })
      # notification elem (notifications tab)
      broadcast_prepend_to(recipient, target: 'notifications', partial: "notifications/notification", locals: { notification: self })
    end
  }

  private

  def recipient_notifications_checked_to_false
    recipient.update(notifications_checked: false) unless type == 'MessageNotification'
  end
end
