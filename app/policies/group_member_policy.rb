class GroupMemberPolicy < ApplicationPolicy
  def create?
    # record is current_user's group member
    is_group_owner?
  end

  def update?
    # record is one being updated
    record_belongs_to_user?
  end

  def destroy?
    # record is one being destroyed
    record_belongs_to_user? || user_is_group_owner?
  end

  private

  def user_is_group_owner?
    group = record.group
    user_group_member = group.group_members.find_by(profile: user.profile)
    return false unless user_group_member
    user_group_member.role == 'owner'
  end

  def is_group_owner?
    # record is a GroupMember instance
    record.role == 'owner'
  end

  def record_belongs_to_user?
    # record is a GroupMember instance
    record.profile == user.profile
  end
end
