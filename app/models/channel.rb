class Channel < ApplicationRecord
  belongs_to :group
  has_many :group_members, through: :group
  has_many :channel_members
  has_many :profiles, through: :channel_members
  has_many :messages, dependent: :destroy

  broadcasts
end
