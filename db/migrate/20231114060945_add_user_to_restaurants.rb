class AddUserToRestaurants < ActiveRecord::Migration[7.1]
  def change
    add_reference :restaurants, :user, foreign_key: true
  end
end
