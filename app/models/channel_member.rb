class ChannelMember < ApplicationRecord
  enum role: ["owner", "admin", "member"]

  belongs_to :channel
  belongs_to :profile

  validates :channel_id, uniqueness: { scope: :profile_id }
end
