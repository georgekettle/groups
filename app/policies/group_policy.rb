class GroupPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    is_group_member?
  end

  def create?
    true
  end

  def update?
    is_group_owner?
  end

  def destroy?
    is_group_owner?
  end

  private

  def is_group_member?
    user.profile.group_members.where(group: record).any?
  end

  def is_group_owner?
    user.profile.group_members.where(group: record, role: "owner").any?
  end
end
