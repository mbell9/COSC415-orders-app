# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_10_30_232058) do
  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.string "email"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "menu_items", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.integer "restaurant_id", null: false
    t.integer "category"
    t.boolean "featured", default: false
    t.boolean "availability", default: true
    t.integer "calories"
    t.integer "spiciness"
    t.integer "stock"
    t.integer "discount"
    t.index ["restaurant_id"], name: "index_menu_items_on_restaurant_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "address"
    t.string "phone_number"
    t.text "operating_hours"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.date "recorded_date"
    t.integer "rating"
    t.text "comment"
    t.integer "user_id", null: false
    t.integer "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_reviews_on_restaurant_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  add_foreign_key "menu_items", "restaurants"
  add_foreign_key "reviews", "restaurants"
  add_foreign_key "reviews", "users"
end
