class Profile < ApplicationRecord
  include ActionText::Attachable

  belongs_to :user
  has_many :group_members
  has_many :groups, through: :group_members
  has_many :channel_members
  has_many :channels, through: :channel_members
  has_many :notifications, as: :recipient, dependent: :destroy

  has_one_attached :avatar

  def sorted_channel_members
    with_messages = self.channel_members.joins(:messages).order('messages.created_at desc').uniq
    without_messages = self.channel_members.where.not(id: with_messages)
    with_messages + without_messages
  end

  def notifications_outstanding?
    notifications_checked == false
  end

  def unread_messages?
    notifications.where(read_at: nil, type: 'MessageNotification').any?
  end

  def index_name
    Rails.env == 'development' ? 'ChannelMember_development' : 'ChannelMember'
  end

  def full_name
    "#{self.first_name&.capitalize}" + "#{' ' if self.first_name}" + "#{self.last_name&.capitalize}"
  end

  def initials
    return "#{self.first_name.first}#{self.last_name.first}".upcase if self.first_name && self.last_name
    return "#{self.user.email[0..1]}".upcase
  end

  # # this is for algolia
  def email
    self.user.email
  end

  # # this is for algolia
  def full_name_changed?
    first_name_changed? || last_name_changed?
  end

  def avatar_template
    render_class = ActionController::Base.new
    render_class.render_to_string(partial:'components/avatar', locals: {profile:self})
  end

  def mention_template
    render_class = ActionController::Base.new
    render_class.render_to_string(partial:'components/mention', locals: {profile:self})
  end

  # action text
  def sgid
    self.attachable_sgid
  end

  # # action text
  # def to_sgid(**options)
  #   self.to_signed_global_id
  # end

  # action text
  def to_attachable_partial_path
    "components/mention"
  end

  # Algolia Search setup
  include AlgoliaSearch
  algoliasearch per_environment: true do
    # # the list of attributes sent to Algolia's API
    attributes :first_name, :last_name, :full_name, :email, :sgid, :avatar_template, :mention_template

    # # `title` is more important than `{story,comment}_text`, `{story,comment}_text` more than `url`, `url` more than `author`
    # # btw, do not take into account position in most fields to avoid first word match boost
    searchableAttributes ['unordered(first_name)', 'unordered(last_name)', 'unordered(full_name)', 'unordered(email)']
  end
end
