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

ActiveRecord::Schema.define(version: 20151007094742) do

  create_table "ancestors", force: :cascade do |t|
    t.integer  "family_id"
    t.string   "family_type"
    t.integer  "consumable_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "ancestors", ["family_id", "family_type", "consumable_id"], name: "index_ancestors_on_family_id_and_family_type_and_consumable_id"

  create_table "consumable_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "consumables", force: :cascade do |t|
    t.integer  "consumable_type_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "name"
    t.string   "barcode"
    t.date     "expiry_date"
    t.date     "arrival_date"
    t.boolean  "depleted",           default: false
    t.string   "lot_number"
    t.string   "supplier"
    t.integer  "batch_number"
    t.integer  "number_of_children", default: 1
  end

  add_index "consumables", ["consumable_type_id"], name: "index_consumables_on_consumable_type_id"

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.integer  "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "login"
    t.string   "swipe_card_id"
    t.string   "barcode"
    t.string   "type"
    t.integer  "status",         default: 0
    t.datetime "deactivated_at"
    t.integer  "team_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "users", ["team_id"], name: "index_users_on_team_id"

end
