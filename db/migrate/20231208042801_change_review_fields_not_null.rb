class ChangeReviewFieldsNotNull < ActiveRecord::Migration[7.1]
  def change
    change_column_null :reviews, :customer_id, false
    change_column_null :reviews, :restaurant_id, false
  end
end
