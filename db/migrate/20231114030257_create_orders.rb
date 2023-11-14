class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :restaurant, null: false, foreign_key: true
      t.string :status
      t.decimal :total_price, precision: 10, scale: 2
      
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
