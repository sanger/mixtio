# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160316142810) do

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "user_id"
    t.string   "action"
    t.string   "record_data"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "audits", ["auditable_type", "auditable_id"], name: "index_audits_on_auditable_type_and_auditable_id"
  add_index "audits", ["user_id"], name: "index_audits_on_user_id"

  create_table "consumable_types", force: :cascade do |t|
    t.string   "name"
    t.integer  "days_to_keep"
    t.integer  "freezer_temperature", default: 0
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "consumables", force: :cascade do |t|
    t.integer  "batch_id"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "name"
    t.string   "barcode"
    t.boolean  "depleted",                            default: false
    t.decimal  "volume",     precision: 10, scale: 3
    t.integer  "unit"
  end

  add_index "consumables", ["batch_id"], name: "index_consumables_on_batch_id"

  create_table "favourites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "consumable_type_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "favourites", ["consumable_type_id"], name: "index_favourites_on_consumable_type_id"
  add_index "favourites", ["user_id"], name: "index_favourites_on_user_id"

  create_table "ingredients", force: :cascade do |t|
    t.integer  "consumable_type_id"
    t.integer  "kitchen_id"
    t.string   "number"
    t.string   "type"
    t.date     "expiry_date"
    t.decimal  "volume",             precision: 10, scale: 3
    t.integer  "unit"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "ingredients", ["consumable_type_id"], name: "index_ingredients_on_consumable_type_id"
  add_index "ingredients", ["kitchen_id"], name: "index_ingredients_on_kitchen_id"

  create_table "kitchens", force: :cascade do |t|
    t.string "name"
    t.string "type"
  end

  create_table "label_types", force: :cascade do |t|
    t.string   "name"
    t.integer  "external_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "mixtures", force: :cascade do |t|
    t.integer  "batch_id"
    t.integer  "ingredient_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "mixtures", ["batch_id"], name: "index_mixtures_on_batch_id"
  add_index "mixtures", ["ingredient_id"], name: "index_mixtures_on_ingredient_id"

  create_table "printers", force: :cascade do |t|
    t.string "name"
  end

  create_table "recipes", force: :cascade do |t|
    t.integer  "consumable_type_id"
    t.integer  "recipe_ingredient_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.integer  "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "users", ["team_id"], name: "index_users_on_team_id"

end
