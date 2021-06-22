class ChannelMemberPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    return is_channel_owner? if record.private?
    is_group_member?
  end

  def update?
    record_belongs_to_user?
  end

  def destroy?
    record_belongs_to_user? || is_channel_owner?
  end

  private

  def is_group_member?
    user.profile.group_members.where(group: record.group).any? # record is a Channel instance
  end

  def is_channel_owner?
    user_channel_member = record.channel_members.find_by(profile: user.profile) # record is a Channel instance
    return false unless user_channel_member
    user_channel_member.role == 'owner'
  end

  def record_belongs_to_user?
    record.profile == user.profile
  end
end
