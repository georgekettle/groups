class Message < ApplicationRecord
  has_rich_text :content

  belongs_to :channel
  has_one :group, through: :channel
  belongs_to :profile
  has_many :notifications, as: :recipient, dependent: :destroy
  has_noticed_notifications

  validates :content, presence: true

  broadcasts_to :channel

  after_create :send_notification

private

  def notification_recipients
    # channel.users.select { |user| user.profile != self.profile }
    channel.users.where.not(profile: self.profile)
  end

  def send_notification
    notification = MessageNotification.with(message: self)
    notification.deliver(notification_recipients)
  end
end
