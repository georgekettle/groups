class CreateChannelMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :channel_members do |t|
      t.references :channel, null: false, foreign_key: true
      t.references :profile, null: false, foreign_key: true
      t.integer :role

      t.timestamps
    end
  end
end
