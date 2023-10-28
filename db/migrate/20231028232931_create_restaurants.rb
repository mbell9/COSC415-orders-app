class CreateRestaurants < ActiveRecord::Migration[7.1]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.text :description
      t.text :address
      t.string :phone_number
      t.text :operating_hours

      t.timestamps
    end
  end
end
