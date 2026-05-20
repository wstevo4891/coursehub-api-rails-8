# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  # Can a user see the list of all users?
  def index?
    user.is_admin?
  end

  # Can a user see a specific user's profile?
  def show?
    admin_or_self?
  end

  # Can a new user be created?
  def create?
    true
  end

  # Can a user update a user account?
  def update?
    admin_or_self?
  end

  # Can a user delete a user account?
  def destroy?
    admin_or_self?
  end

  private

  def admin_or_self?
    user.is_admin? || record == user
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.is_admin?
        scope.all
      else
        scope.where(id: user.id)
      end
    end
  end
end
