# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_07_01_085213) do

  create_table "courses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.float "ascent_time", null: false
    t.float "descent_time", null: false
    t.integer "level", null: false
    t.decimal "starting_point_lat", precision: 10, scale: 7, null: false
    t.decimal "starting_point_lng", precision: 10, scale: 7, null: false
    t.bigint "mountain_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["mountain_id"], name: "index_courses_on_mountain_id"
  end

  create_table "equipments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title", null: false
    t.text "body", null: false
    t.string "ware_name", null: false
    t.text "ware_description", null: false
    t.string "gear_name", null: false
    t.text "gear_description", null: false
    t.integer "lower_limit_temp", null: false
    t.integer "max_elevation", null: false
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "mountains", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.integer "elevation", null: false
    t.integer "prefecture_code", null: false
    t.string "city", null: false
    t.decimal "peak_location_lat", precision: 10, scale: 7, null: false
    t.decimal "peak_location_lng", precision: 10, scale: 7, null: false
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "courses", "mountains"
end
