class ChannelMember < ApplicationRecord
  enum role: ["owner", "admin", "member"]

  belongs_to :channel
  has_one :group, through: :channel
  belongs_to :profile
end
