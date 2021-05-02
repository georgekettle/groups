class GroupMember < ApplicationRecord
  enum role: ["owner", "admin", "member"]

  belongs_to :profile
  belongs_to :group

  before_create :add_to_default_channels

private

  def add_to_default_channels
    self.group.default_channels.each do |channel|
      ChannelMember.create(channel: channel, profile: self.profile, role: self.role)
    end
  end
end
