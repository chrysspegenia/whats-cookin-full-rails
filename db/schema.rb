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

ActiveRecord::Schema[7.1].define(version: 2024_06_06_123535) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ingredients", force: :cascade do |t|
    t.string "name"
    t.integer "quantity"
    t.bigint "user_id", null: false
    t.bigint "inventory_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_grocery_item", default: false
    t.index ["inventory_id"], name: "index_ingredients_on_inventory_id"
    t.index ["user_id"], name: "index_ingredients_on_user_id"
  end

  create_table "inventories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_inventories_on_user_id"
  end

  create_table "meal_plans", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "recipe_id", null: false
    t.string "meal_type"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_meal_plans_on_recipe_id"
    t.index ["user_id", "meal_type", "date"], name: "index_meal_plans_on_user_id_and_meal_type_and_date", unique: true
    t.index ["user_id"], name: "index_meal_plans_on_user_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "title", null: false
    t.text "instructions", null: false
    t.string "image_url", null: false
    t.text "health_labels", default: [], array: true
    t.float "calories"
    t.string "cuisine_type", default: [], array: true
    t.string "meal_type", default: [], array: true
    t.integer "serving"
    t.string "url_source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.boolean "isUserCreated"
    t.jsonb "ingredients", default: []
    t.index ["user_id"], name: "index_recipes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "ingredients", "inventories"
  add_foreign_key "ingredients", "users"
  add_foreign_key "inventories", "users"
  add_foreign_key "meal_plans", "recipes"
  add_foreign_key "meal_plans", "users"
  add_foreign_key "recipes", "users"
end
