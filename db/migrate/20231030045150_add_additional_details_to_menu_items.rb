class AddAdditionalDetailsToMenuItems < ActiveRecord::Migration[7.1]
  def change
    add_column :menu_items, :category, :integer
    add_column :menu_items, :featured, :boolean, default: false
    add_column :menu_items, :availability, :boolean, default: true
    add_column :menu_items, :calories, :integer
    add_column :menu_items, :spiciness, :integer
  end
end
