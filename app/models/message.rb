class Message < ApplicationRecord
  has_rich_text :content

  belongs_to :channel
  has_one :group, through: :channel
  belongs_to :profile

  validates :content, presence: true

  broadcasts_to :channel
  # after_create_commit-> { broadcast_append_to_self }
end
