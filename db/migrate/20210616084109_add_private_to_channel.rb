class AddPrivateToChannel < ActiveRecord::Migration[6.0]
  def change
    add_column :channels, :private, :boolean, null: false, default: false
  end
end
