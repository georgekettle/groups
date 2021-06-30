class MessagePolicy < ApplicationPolicy
  def create?
    is_channel_member?
  end

  def update?
    belongs_to_user?
  end

  def destroy?
    belongs_to_user?
  end

  private

  def belongs_to_user?
    record.profile == user.profile
  end

  def is_channel_member?
    channel = record.channel
    channel.channel_members.find_by(profile: user.profile)
  end
end
