class ChangeUserReferenceInReviews < ActiveRecord::Migration[7.1]
  def change
    remove_reference :reviews, :user, index: true, foreign_key: true
    add_reference :reviews, :customer, index: true, foreign_key: true
  end
end
