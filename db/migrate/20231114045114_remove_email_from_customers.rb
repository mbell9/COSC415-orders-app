class RemoveEmailFromCustomers < ActiveRecord::Migration[7.1]
  def change
    remove_column :customers, :email, :string
  end
end
