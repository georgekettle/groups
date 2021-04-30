class Group < ApplicationRecord
  has_many :group_members
  has_many :profiles, through: :group_members
  has_many :channels

  before_create :create_channels

  def group_members_count_string
    "#{self.group_members.count} #{'member'.pluralize(self.group_members.count)}"
  end

private

  def create_channels
    general = self.channels.build(name: 'general')
    general = self.channels.build(name: 'announcements')
  end
end
