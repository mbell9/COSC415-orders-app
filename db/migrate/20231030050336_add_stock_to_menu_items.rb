class AddStockToMenuItems < ActiveRecord::Migration[7.1]
  def change
    add_column :menu_items, :stock, :integer
  end
end
