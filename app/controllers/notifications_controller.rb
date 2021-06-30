class NotificationsController < ApplicationController
  skip_after_action :verify_policy_scoped, only: [:index]

  def index
    current_user.profile.update(notifications_checked: true)
    @notifications = current_user.profile.notifications.newest_first.where(type: 'MentionNotification')
  end
end
