class Channel < ApplicationRecord
  belongs_to :group
  has_many :group_members, through: :group

  has_many :channel_members, inverse_of: :channel, dependent: :destroy
  has_many :messages, through: :channel_members
  has_many :profiles, through: :channel_members
  has_many :users, through: :profiles

  accepts_nested_attributes_for :channel_members, reject_if: :all_blank, allow_destroy: true

  validates :name, uniqueness: { scope: :group_id }, presence: true

  def display_name
    name.capitalize
  end

  def primary?
    primary
  end
end
