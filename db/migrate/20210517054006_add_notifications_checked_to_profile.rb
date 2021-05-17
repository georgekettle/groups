class AddNotificationsCheckedToProfile < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :notifications_checked, :boolean, default: true, null: false
  end
end
