class AddUniqueIndexToChannelMembers < ActiveRecord::Migration[6.0]
  def change
    add_index :channel_members, [:profile_id, :channel_id], unique: true
  end
end
