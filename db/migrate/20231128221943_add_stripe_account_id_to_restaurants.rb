class AddStripeAccountIdToRestaurants < ActiveRecord::Migration[7.1]
  def change
    add_column :restaurants, :stripe_account_id, :string
    add_column :restaurants, :string, :string
  end
end
