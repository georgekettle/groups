class GroupMember < ApplicationRecord
  enum role: ["owner", "admin", "member"]

  belongs_to :profile
  belongs_to :group

  validates :group_id, uniqueness: { scope: :profile_id }

  before_create :add_to_default_channels
  before_destroy :delete_channel_subscriptions

  # Algolia Search setup
  def self.index_name
    Rails.env == 'development' ? 'GroupMember_development' : 'GroupMember'
  end

  include AlgoliaSearch
  algoliasearch per_environment: true do
    # # the list of attributes sent to Algolia's API
    attributes :profile do
      # restrict the nested "profile" object to its `name` + `email`
      { objectID: profile.id, first_name: profile.first_name, last_name: profile.last_name, full_name: profile.full_name, email: profile.email, avatar_template: profile.avatar_template }
    end

    attributes :group do
      # restrict the nested "profile" object to its `name` + `email`
      { objectID: group.id, name: group.name }
    end

    # # `title` is more important than `{story,comment}_text`, `{story,comment}_text` more than `url`, `url` more than `author`
    # # btw, do not take into account position in most fields to avoid first word match boost
    # searchableAttributes ['unordered(first_name)', 'unordered(last_name)', 'unordered(full_name)', 'unordered(email)']
    searchableAttributes ['unordered(profile.first_name)', 'unordered(profile.last_name)', 'unordered(profile.full_name)', 'unordered(profile.email)']
    attributesForFaceting [:group]
  end

private

  def add_to_default_channels
    self.group.default_channels.each do |channel|
      member = ChannelMember.new(channel_id: channel.id, profile_id: self.profile.id, role: self.role)
      member.save
    end
  end

  def delete_channel_subscriptions
    channel_members = ChannelMember.joins(:channel).where(channels: { group: self.group }, profile: self.profile)
    channel_members.each(&:destroy)
  end
end
