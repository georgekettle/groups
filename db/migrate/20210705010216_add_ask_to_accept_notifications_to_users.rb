class AddAskToAcceptNotificationsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :ask_to_accept_notifications, :boolean, null: false, default: true
  end
end
