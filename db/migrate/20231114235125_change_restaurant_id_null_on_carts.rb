class ChangeRestaurantIdNullOnCarts < ActiveRecord::Migration[7.1]
  def change
    change_column_null :carts, :restaurant_id, true
  end
end
