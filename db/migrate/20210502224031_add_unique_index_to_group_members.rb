class AddUniqueIndexToGroupMembers < ActiveRecord::Migration[6.0]
  def change
    add_index :group_members, [:profile_id, :group_id], unique: true
  end
end
