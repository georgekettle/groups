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
    record_belongs_to_user? || channel_member_is_owner?
  end

  private

  def is_group_member?
    # record is a Channel instance
    user.profile.group_members.where(group: record.group).any?
  end

  def is_channel_owner?
    # record is a Channel instance
    user_channel_member = record.channel_members.find_by(profile: user.profile)
    return false unless user_channel_member
    user_channel_member.role == 'owner'
  end

  def channel_member_is_owner?
    user_channel_member = record.channel.channel_members.find_by(profile: user.profile)
    return false unless user_channel_member
    user_channel_member.role == 'owner'
  end

  def record_belongs_to_user?
    # record is a ChannelMember instance
    record.profile == user.profile
  end
end
