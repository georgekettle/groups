class AddMutedToChannelMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :channel_members, :muted, :boolean, default: false, null: false
  end
end
