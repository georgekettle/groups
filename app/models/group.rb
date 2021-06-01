class Group < ApplicationRecord
  DEFAULT_CHANNELS = %w(general announcements)
  has_many :group_members, inverse_of: :group, dependent: :destroy
  accepts_nested_attributes_for :group_members, reject_if: :all_blank, allow_destroy: true
  has_many :profiles, through: :group_members
  has_many :channels, dependent: :destroy
  has_many :channel_members, through: :channels, dependent: :destroy

  before_create :create_default_channels

  validates :name, presence: true

  def group_members_count_string
    "#{self.group_members.count} #{'member'.pluralize(self.group_members.count)}"
  end

  def default_channels
    channels.where(primary: true)
  end

private

  def create_default_channels
    DEFAULT_CHANNELS.each do |channel|
      channel = self.channels.build(name: channel, primary: true)
      add_group_members_to_channel(channel)
    end
  end

  def add_group_members_to_channel(channel)
    self.group_members.each {|member| channel.channel_members.build(profile: member.profile, role: member.role)}
  end
end
