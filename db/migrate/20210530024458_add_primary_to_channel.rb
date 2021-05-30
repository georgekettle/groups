class AddPrimaryToChannel < ActiveRecord::Migration[6.0]
  def change
    add_column :channels, :primary, :boolean, default: false, null: false
  end
end
