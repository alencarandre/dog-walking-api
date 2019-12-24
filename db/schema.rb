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

ActiveRecord::Schema.define(version: 2019_12_23_015530) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dog_breeds", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "dog_walking_dogs", force: :cascade do |t|
    t.bigint "dog_walking_id", null: false
    t.bigint "dog_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dog_id"], name: "index_dog_walking_dogs_on_dog_id"
    t.index ["dog_walking_id"], name: "index_dog_walking_dogs_on_dog_walking_id"
  end

  create_table "dog_walkings", force: :cascade do |t|
    t.string "status"
    t.float "latitude"
    t.float "longitude"
    t.integer "duration"
    t.float "price"
    t.float "final_price"
    t.datetime "scheduled_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "dogs", force: :cascade do |t|
    t.string "name"
    t.string "breed"
    t.integer "age"
    t.bigint "dog_breed_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dog_breed_id"], name: "index_dogs_on_dog_breed_id"
  end

  create_table "table_prices", force: :cascade do |t|
    t.integer "cadence"
    t.float "price"
    t.float "price_additional"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "dog_walking_dogs", "dog_walkings"
  add_foreign_key "dog_walking_dogs", "dogs"
  add_foreign_key "dogs", "dog_breeds"
end
