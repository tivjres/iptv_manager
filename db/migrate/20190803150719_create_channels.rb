class CreateChannels < ActiveRecord::Migration[5.2]
  def change
    create_table :channels do |t|
      t.string :url
      t.string :name
      t.integer :status

      t.timestamps
    end
  end
end
