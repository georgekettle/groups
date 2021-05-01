class Channel < ApplicationRecord
  belongs_to :group
  has_many :messages, dependent: :destroy

  broadcasts
end
