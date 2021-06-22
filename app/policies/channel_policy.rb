class ChannelPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.select do |channel|
        ChannelMember.find_by(channel: channel, profile: user.profile) || !channel.private?
      end
    end
  end

  def show?
    is_group_member?
  end

  def update?
    is_channel_owner?
  end

  def create?
    is_group_member?
  end

  def destroy?
    is_channel_owner?
  end

  private

  def is_channel_member?
    record.channel_members.where(profile: user.profile).present?
  end

  def is_channel_owner?
    user.profile.channel_members.where(channel: record, role: "owner").any?
  end

  def is_group_member?
    record.group.group_members.where(profile: user.profile).present?
  end
end
