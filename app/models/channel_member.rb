class ChannelMember < ApplicationRecord
  enum role: ["owner", "admin", "member"]

  belongs_to :channel
  belongs_to :profile
  has_many :messages

  validates :channel_id, uniqueness: { scope: :profile_id }

  def muted?
    muted
  end

  def unread_messages?
    profile.notifications.where(read_at: nil, type: 'MessageNotification').any?{|n| n.params[:message].channel == channel}
  end

  # Algolia Search setup
  def self.index_name
    Rails.env == 'development' ? 'ChannelMember_development' : 'ChannelMember_production'
  end

  include AlgoliaSearch
  algoliasearch per_environment: true do
    # # the list of attributes sent to Algolia's API
    attributes :profile do
      # restrict the nested "profile" object to its `name` + `email`
      { objectID: profile.id, first_name: profile.first_name, last_name: profile.last_name, full_name: profile.full_name, email: profile.email, avatar_template: profile.avatar_template }
    end

    attributes :channel do
      # restrict the nested "profile" object to its `name` + `email`
      { objectID: channel.id, name: channel.name }
    end

    # # `title` is more important than `{story,comment}_text`, `{story,comment}_text` more than `url`, `url` more than `author`
    # # btw, do not take into account position in most fields to avoid first word match boost
    # searchableAttributes ['unordered(first_name)', 'unordered(last_name)', 'unordered(full_name)', 'unordered(email)']
    searchableAttributes ['unordered(profile.first_name)', 'unordered(profile.last_name)', 'unordered(profile.full_name)', 'unordered(profile.email)']
    attributesForFaceting [:channel]
  end
end
