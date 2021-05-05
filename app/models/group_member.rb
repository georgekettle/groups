class GroupMember < ApplicationRecord
  enum role: ["owner", "admin", "member"]

  belongs_to :profile
  belongs_to :group

  validates :group_id, uniqueness: { scope: :profile_id }

  before_create :add_to_default_channels
  before_destroy :delete_channel_subscriptions

private

  def add_to_default_channels
    self.group.default_channels.each do |channel|
      member = ChannelMember.new(channel_id: channel.id, profile_id: self.profile.id, role: self.role)
      member.save
    end
  end

  def delete_channel_subscriptions
    channel_members = ChannelMember.joins(:channel).where(channels: { group: self.group }, profile: self.profile)
    channel_members.each(&:destroy)
  end
end
