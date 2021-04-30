class Message < ApplicationRecord
  belongs_to :channel
  has_one :group, through: :channel
  belongs_to :profile
end
