class Message < ApplicationRecord
  has_rich_text :content

  belongs_to :channel_member
  has_one :channel, through: :channel_member
  has_one :group, through: :channel
  has_one :profile, through: :channel_member

  has_many :notifications, as: :recipient, dependent: :destroy
  has_noticed_notifications

  validates :content, presence: true

  # broadcasts_to :channel

  after_create :send_channel_notification
  after_create :send_mention_notifications

private

  def notification_recipients
    channel.profiles.where.not(id: profile.id)
  end

  def send_channel_notification
    notification = MessageNotification.with(message: self)
    notification.deliver(notification_recipients)
  end

  def send_mention_notifications
    profiles = profile_mentions
    notification = MentionNotification.with(message: self)
    notification.deliver(profiles)
  end

  def profile_mentions
    @profiles ||= content.body.attachments.select{ |a| a.attachable.class == Profile }.map(&:attachable).uniq
  end
end
