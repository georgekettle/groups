class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.references :channel, null: false, foreign_key: true
      t.references :profile, null: false, foreign_key: true
      t.string :content

      t.timestamps
    end
  end
end
