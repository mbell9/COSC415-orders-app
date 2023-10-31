class AddDiscountToMenuItems < ActiveRecord::Migration[7.1]
  def change
    add_column :menu_items, :discount, :integer
  end
end
