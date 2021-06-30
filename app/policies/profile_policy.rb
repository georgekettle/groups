class ProfilePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    true
  end

  def update?
    belongs_to_user?
  end

  def destroy?
    belongs_to_user?
  end

  def edit_avatar?
    belongs_to_user?
  end

  def search?
    true
  end

  private

  def belongs_to_user?
    record == user.profile
  end
end
