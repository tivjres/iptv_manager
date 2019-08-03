class AddGroupToChannel < ActiveRecord::Migration[5.2]
  def change
    add_reference :channels, :group, foreign_key: true
  end
end
