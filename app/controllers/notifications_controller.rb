class NotificationsController < ApplicationController
  def index
    current_user.profile.update(notifications_checked: true)
    @notifications = current_user.profile.notifications.newest_first.where(type: 'MentionNotification')
  end
end
