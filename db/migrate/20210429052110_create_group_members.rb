class CreateGroupMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :group_members do |t|
      t.references :profile, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true
      t.integer :role

      t.timestamps
    end
  end
end
