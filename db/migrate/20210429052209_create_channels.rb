class CreateChannels < ActiveRecord::Migration[6.0]
  def change
    create_table :channels do |t|
      t.string :name
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
