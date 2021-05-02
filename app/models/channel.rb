class Channel < ApplicationRecord
  belongs_to :group
  has_many :group_members, through: :group
  has_many :channel_members, inverse_of: :group, dependent: :destroy
  accepts_nested_attributes_for :channel_members, reject_if: :all_blank, allow_destroy: true
  has_many :profiles, through: :channel_members
  has_many :messages, dependent: :destroy

  validates :name, uniqueness: { scope: :group_id }

  broadcasts
end
