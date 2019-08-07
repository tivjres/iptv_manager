class CreateListItems < ActiveRecord::Migration[5.2]
  def change
    create_table :list_items do |t|
      t.references :user, foreign_key: true
      t.references :list, foreign_key: true
      t.integer :position
      t.references :channel, foreign_key: true

      t.timestamps
    end
  end
end
