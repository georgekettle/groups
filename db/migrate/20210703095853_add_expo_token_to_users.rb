class AddExpoTokenToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :expo_token, :string
  end
end
