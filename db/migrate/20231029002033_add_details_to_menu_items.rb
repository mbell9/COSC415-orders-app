class AddDetailsToMenuItems < ActiveRecord::Migration[7.1]
  def change
    add_column :menu_items, :description, :text
    add_reference :menu_items, :restaurant, null: false, foreign_key: true
  end
end
